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

  Myapp.Models.Flavor = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      image: ''
      type: 'flavor'

  Myapp.Collections.Flavors = Backbone.Collection.extend
    model: Myapp.Models.Flavor
    url: '/flavors'

  Myapp.Models.Plan = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      type: 'plan'

  Myapp.Collections.Plans = Backbone.Collection.extend
    model: Myapp.Models.Plan
    url: '/plans'

  Myapp.Models.Accessory = Myapp.Models.ItemModel.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      image: ''
      type: 'accessory'

  Myapp.Collections.Accessories = Backbone.Collection.extend
    model: Myapp.Models.Accessory
    url: '/accessories'


  Myapp.Views.ItemView = Backbone.View.extend
    className: 'single-item'
    tagName: 'li'
    template: JST['backbone/templates/itemTemplate']
    render: ->
      @$el.html @template(item: @model)
    events:
      'click' : 'addToCart'
    addToCart: ->
      debugger
      newItemCart = new Myapp.Views.ItemCartView(model: @.model)
      window.cart.add(@.model)
      newItemCart.render()
      

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
    typeList:
      type: ['plan','flavor','accessory']
    render: ->
      @.$el.html(@template(item: @model))
      debugger
      $('#step-' + (@.typeList.type.indexOf(@model.get('type'))+1) + " .steps-header .items-container").append(@.$el)


  # Myapp.Views.ShoppingCartView = Backbone.View.extend
  #   initialize:
      # something about binding add to item cart view, then remove the render shit
      # calculating totla price on add or remove as well
      # bind remove
      # renderCart
      # probably move the itemcartview render to here too and typelist


  window.plans = new Myapp.Collections.Plans()
  window.accessories = new Myapp.Collections.Accessories()
  window.flavors = new Myapp.Collections.Flavors()
  plans.fetch()
  test = new Myapp.Views.StepView(collection: plans)
  window.cart = new Myapp.Collections.ShoppingCart()
  shoppingCartView = new Myapp.Views.ShoppingCartView(window.cart)


