#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Myapp =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

jQuery ->
  currentStep = 1
  Myapp = window.Myapp or {};
  
  Myapp.Models.ItemModel = Backbone.Model.extend
    defaults:
      type: 'Unknown'

  Myapp.Collections.ShoppingCart = Backbone.Collection.extend
    url: '/create_subscription'
    byType: (type) ->
      filtered = @.filter((item) ->
        item.get('type') is type
      )
      return new Myapp.Collections.ShoppingCart(filtered)
    calculateSubtotal: ->
      subtotal = 0
      @.each ((item) ->
        if item.get('cost')
          if item.get('quantity')
            subtotal = subtotal + (parseInt(item.get('cost')) * parseInt(item.get('quantity')))
          else
            subtotal = subtotal + parseInt(item.get('cost'))
      )
      shipping = 0
      $('#shipping-cost').html("Shipping: $" + shipping.toFixed(2))
      $('#subtotal-price').html("Subtotal: $" + subtotal.toFixed(2))

  Myapp.Models.Flavor = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      image: ''
      type: 'flavor'
    idAttribute: 'uniqueId'
    parse: (response) ->
      response.uniqueId = 'flavor_'+response.id
      return response

  Myapp.Collections.Flavors = Backbone.Collection.extend
    model: Myapp.Models.Flavor
    url: '/flavors'

  Myapp.Models.Plan = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      type: 'plan'
    idAttribute: 'uniqueId'
    parse: (response) ->
      response.cost = parseInt(response.cost).toFixed(2)
      response.uniqueId = 'plan_'+response.id
      return response

  Myapp.Collections.Plans = Backbone.Collection.extend
    model: Myapp.Models.Plan
    url: '/plans'

  Myapp.Models.Accessory = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      image: ''
      type: 'accessory'
    idAttribute: 'uniqueId'
    parse: (response) ->
      response.cost = parseInt(response.cost).toFixed(2)
      response.uniqueId = 'accessory_'+response.id
      return response

  Myapp.Collections.Accessories = Backbone.Collection.extend
    model: Myapp.Models.Accessory
    url: '/accessories'


  Myapp.Views.ItemView = Backbone.View.extend
    className: 'single-item'
    tagName: 'li'
    template: JST['backbone/templates/itemTemplate']
    render: ->
      debugger
      @$el.html @template(item: @model)
    events:
      'click' : 'addToCart'
    addToCart: ->
      if @.model.get('type') is 'plan'
        window.cart.remove(window.cart.byType('plan').models)
        window.cart.add(@.model)
      else if window.cart.contains(@.model)
        modelQuantity = window.cart.get(@.model).get('quantity')
        window.cart.get(@.model).set(quantity: modelQuantity+1)
      else
        @.model.set(quantity: 1)
        window.cart.add(@.model)

      

  Myapp.Views.StepView = Backbone.View.extend
    initialize: (options) ->
      @.options = options
      if @collection
        @collection.bind('reset', @render , @ )
      else
        @template = options.template
      return @
    template: JST['backbone/templates/stepsTemplate']

    el: '.steps-content'
    stepsList: 
      steps: ['plans','flavors','accessories', 'form', 'checkout']
    events:
      'click .continue' : 'nextStep'
      'click .back' : 'backStep'
    nextStep: ->
      @.undelegateEvents()
      if window[@.stepsList.steps[currentStep]]
        window[@.stepsList.steps[currentStep]].fetch()
        test = new Myapp.Views.StepView(collection: window[@.stepsList.steps[currentStep]])
        currentStep = currentStep + 1
      else
        test = new Myapp.Views.StepView(template: JST['backbone/templates/'+ this.stepsList.steps[currentStep] + 'Template'])
        currentStep = currentStep + 1
        test.renderForm()
    backStep: ->
      @.undelegateEvents()
      if window[@.stepsList.steps[currentStep-2]]
        window[@.stepsList.steps[currentStep-2]].fetch()
        test = new Myapp.Views.StepView(collection: window[@.stepsList.steps[currentStep-2]])
        currentStep = currentStep - 1
      else
        test = new Myapp.Views.StepView(template: JST['backbone/templates/'+ this.stepsList.steps[currentStep-2] + 'Template'])
        currentStep = currentStep - 1
        test.renderForm()


    render: ->
      @.$el.html( @.template(currentStep: currentStep) )
      @collection.each ((item) ->
        @$(".products-container").append new Myapp.Views.ItemView(model: item).render()
      ), this

      $('#step-' + (currentStep)).after(@.$el)
      return @
    renderForm: ->
      @.$el.html( @.template( currentStep: currentStep) )
      $('#step-' + (currentStep)).after(@.$el)

  Myapp.Views.ItemCartView = Backbone.View.extend
    className: 'steps-item'
    tagName: 'div'
    template: JST['backbone/templates/itemCartTemplate']
    events:
      'click .item-close' : 'removeItem'
    removeItem: ->
      window.cart.remove(@.model)
      @.undelegateEvents()
      @.remove()
      window.cart.calculateSubtotal()
    render: ->
      @.$el.html(@template(item: @model))
      


  Myapp.Views.ShoppingCartView = Backbone.View.extend
    initialize: ->
      @collection.bind('change', @render , @ )
      @collection.bind('add', @render , @ )
    typeList:
      type: ['plan','flavor','accessory']
    render: (event) ->
      @.collection.calculateSubtotal()
      type = event.get('type')
      step = @.typeList.type.indexOf(type) + 1
      $('#step-' + step + ' .items-container').empty()
      @collection.byType(type).each ((item) ->
        $('#step-' + step + ' .items-container').append new Myapp.Views.ItemCartView(model: item).render()
      ), this
      
      # each model
      # newItemCart = new Myapp.Views.ItemCartView(model: @.model)
      # $('#step-' + (@.typeList.type.indexOf(@model.get('type'))+1) + " .steps-header .items-container").html(@.$el)



      # something about binding add to item cart view, then remove the render shit
      # calculating totla price on add or remove as well
      # bind remove
      # renderCart
      # probably move the itemcartview render to here too and typelist
  

  window.plans = new Myapp.Collections.Plans()
  window.accessories = new Myapp.Collections.Accessories()
  window.flavors = new Myapp.Collections.Flavors()
  window.cart = new Myapp.Collections.ShoppingCart()
  plans.fetch()
  test = new Myapp.Views.StepView(collection: plans)
  shoppingCartView = new Myapp.Views.ShoppingCartView(collection: window.cart)

  


