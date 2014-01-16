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
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  currentStep = 1
  Myapp = window.Myapp or {}
  Myapp.Models.User = Backbone.Model.extend
  Myapp.Models.UserAddress = Backbone.Model.extend



  Myapp.Models.ItemModel = Backbone.Model.extend
    defaults:
      type: 'Unknown'
      selected: false

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
      #define shipping based on plan
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
    byLevel: (level) ->
      filtered = @.filter((item) ->
        item.get('level') is level
      )
      return new Myapp.Collections.Flavors(filtered)

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


  Myapp.Views.ActionItemView = Backbone.View.extend
    initialize: ->
      # bind to changes in shopping cart
      window.cart.bind('remove', @changeSelected, @)
    template: JST['backbone/templates/actionItemTemplate']
    changeSelected: (event) ->
      # remove selected buttons
      if event.id is @.model.id
        @.model.set(selected: false)
        @.render()
      return @
    addToCart: ->
      #for adding up quantities or adding new item
      if _.pluck(window.cart.models, 'id').indexOf(this.model.id) >= 0
        modelQuantity = window.cart.get(@.model).get('quantity')
        window.cart.get(@.model).set(quantity: modelQuantity+1)
      else
        @.model.set(quantity: 1, selected: true)
        window.cart.add(@.model)
    events:
      'click': 'addToCart'
    render: ->
      debugger
      @$el.html @template(item: @model)

  Myapp.Views.ItemView = Backbone.View.extend
    className: 'single-item'
    tagName: 'li'
    template: JST['backbone/templates/itemTemplate']
    render: ->
      if window.cart.where({ uniqueId: this.model.get('uniqueId')}).length
        this.model.set(selected: true)
      if this.model.get('type') is 'flavor'
        if this.model.get('level') is '0'
          template = JST['backbone/templates/flavorTemplate']
          @$el.html template(item: @model)
      else
        template = @.template
        @$el.html template(item: @model)
    
    events:
      'click .plan-add' : 'addToCart'
      # 'click .remove-quantity' : 'removeQuantity'
    removeQuantity: ->
      quantity = window.cart.get(@.model).get('quantity')
      if quantity > 1
        window.cart.get(@.model).set(quantity: quantity-1)
        return @
      else
        window.cart.remove(@.model)
        return @
    addToCart: ->
      $('#errors').empty()
      window.cart.remove(window.cart.byType('plan').models)
      window.cart.add(@.model)
      @.model.set(selected: true)
      #for adding up quantities or adding new item
      # else if _.pluck(window.cart.models, 'id').indexOf(this.model.id) >= 0
      #   modelQuantity = window.cart.get(@.model).get('quantity')
      #   window.cart.get(@.model).set(quantity: modelQuantity+1)
      # else
      #   @.model.set(quantity: 1, selected: true)
      #   window.cart.add(@.model)

      

  Myapp.Views.StepView = Backbone.View.extend
    initialize: (options) ->
      @.options = options
      @options.collectionA.bind('reset', @render , @ )
    
      return @
    template: JST['backbone/templates/stepsTemplate']
    initializeShippingForm: ->
      @.form = this.$el.find('form');
      @.firstNameField = @.$el.find('input[name=first-name]');
      @.lastNameField = @.$el.find('input[name=last-name]');
      @.Address1Field = @.$el.find('input[name=address1]');
      @.Address2Field = @.$el.find('input[name=address2]');
      @.CityField = @.$el.find('input[name=city]');
      @.StateField = @.$el.find('input[name=state]');
      @.ZipField = @.$el.find('input[name=zip]');
      @.shipAddress1Field = @.$el.find('input[name=ship-address1]');
      @.shipAddress2Field = @.$el.find('input[name=ship-address2]');
      @.shipCityField = @.$el.find('input[name=ship-city]');
      @.shipStateField = @.$el.find('input[name=ship-state]');
      @.shipZipField = @.$el.find('input[name=ship-zip]');
      @.emailField = @.$el.find('input[name=email]');
      @.passwordField = @.$el.find('input[name=password]');
      @.passwordConfirmationField = @.$el.find('input[name=password-confirmation]');
    addressAttributes: ->
      address1: @.Address1Field.val()
      address2: @.Address2Field.val()
      city: @.CityField.val()
      state: @.StateField.val()
      zip: @.ZipField.val()
      shipAddress: @.shipAddress1Field.val()
      shipAddress2: @.shipAddress2Field.val()
      shipCity: @.shipCityField.val()
      shipState: @.shipStateField.val()
      shipZip: @.shipZipField.val()
    accountAttributes: ->
      firstName: @.firstNameField.val()
      lastName: @.lastNameField.val()
      email: @.emailField.val()
      password: @.passwordField.val()
      passwordConfirmation: @.passwordConfirmationField.val()
    initializeCheckoutForm: ->
      @.form = @.$el.find('form');

    el: '.steps-content'
    stepsList: 
      steps: ['plans','flavors','accessories', 'form', 'checkout']
      stepsSingular: ['plan','flavor','accessory']
    events:
      'click #process-registration' : 'processRegistration'
      'click .continue' : 'nextStep'
      'click .back' : 'backStep'
      'click #ship-address-check' : 'toggleShipping'
      'change #flavor-level-select' : 'render'
    processRegistration: ->
      card =
        number: $('input[data-stripe=number]').val()
        cvc: $('input[data-stripe=cvc]').val()
        expMonth: $('input[data-stripe=exp-month]').val()
        expYear: $('input[data-stripe=exp-year]').val()
      Stripe.createToken(card, @.handleStripeResponse)
    handleStripeResponse: (status, response) ->
      debugger
      if status == 200
        alert(response.id)
      else
        alert(response.error.message)

    findFlavorDifference: ->
        flavorCountPlan = window.cart.byType('plan').first().get('flavor_count')
        flavorCountCart = _.reduce window.cart.byType("flavor").models, ((sumQuantity, model) ->
          sumQuantity + model.get("quantity")
        ), 0
        flavorDifference = flavorCountPlan - flavorCountCart
        return flavorDifference
    validateStep: ->
      errors = []
      if currentStep is 1
        if window.cart.byType('plan').length is 0
          errors.push 'You need to pick at least one plan'
          return errors
      if currentStep is 2
        flavorDifference = @.findFlavorDifference()
        if flavorDifference > 0
          errors.push 'You need to pick ' + flavorDifference + ' more flavors.'
          return errors
        else if flavorDifference < 0
          errors.push 'You need to remove ' + (flavorDifference*-1) + ' flavors.'
          return errors
    toggleShipping: ->
      if document.getElementById('ship-address-check')
        if document.getElementById('ship-address-check').checked
          $('#ship-address-form').slideUp()
        else
          $('#ship-address-form').slideDown()

    nextStep: ->
      errors = @.validateStep()
      if errors
        $('#errors').empty()
        _.each errors, (error) ->
          $('#errors').append error
        return @
      currentStep = currentStep + 1
      @.render()
      debugger
      window.shoppingCartView.render(null, currentStep-1, this.stepsList.stepsSingular[currentStep-2])
      debugger

    backStep: ->
      debugger
      currentStep = currentStep - 1
      @.render()  
      window.shoppingCartView.render(null, currentStep+1, this.stepsList.stepsSingular[currentStep])      

    handleClickableAndInactiveTabs: ->
      $('#step-' + (currentStep)).removeClass 'inactive'
      $('#step-' + (currentStep)).removeClass 'clickable'
      i = 0
      while i < 5
        $($(".steps-wrapper")[i]).addClass "clickable"  if i < currentStep - 1
        $(".steps-wrapper").addClass "inactive"
        i++
      $('#step-' + (currentStep)).removeClass 'inactive'
      $('#step-' + (currentStep)).after(@.$el)

    render: ->
      if currentStep is 1
        collection = this.options.collectionA
        template = @.template
      else if currentStep is 2
        collection = this.options.collectionB
        template = @.template
      else if currentStep is 3
        collection = this.options.collectionC
        template = @.template
      else if currentStep is 4
        template = JST['backbone/templates/'+ this.stepsList.steps[currentStep-1] + 'Template']
      else if currentStep is 5
        template = JST['backbone/templates/'+ this.stepsList.steps[currentStep-1] + 'Template']

      @.$el.html( template(currentStep: currentStep) )
      if currentStep is 3
        @initializeShippingForm()
      if currentStep is 4
        @initializeCheckoutForm()
      if collection
        collection.each ((item) ->
          @$(".products-container").append new Myapp.Views.ItemView(model: item).render()
        ), this
        if currentStep is 2
          collection.each ((item) ->
            @.$(".select-container[data-name=" + item.get('name')+"]" ).append new Myapp.Views.ActionItemView(model: item).render()
          ), this
        else
          collection.each ((item) ->
            @.$(".select-container[data-name=" + item.get('uniqueId')+"]" ).append new Myapp.Views.ActionItemView(model: item).render()
          ), this

      @handleClickableAndInactiveTabs()
      return @

  Myapp.Views.ItemCartView = Backbone.View.extend
    initialize: ->
      @model.bind('change:quantity', @render , @ )
      @model.bind('remove', @removeItem , @ )
    className: 'steps-item'
    tagName: 'div'
    template: JST['backbone/templates/itemCartTemplate']
    events:
      'click .item-close' : 'removeItem'
    removeItem: ->
      if @.$el.closest('.steps-wrapper').data('step') != currentStep
        return @
      window.cart.remove(@.model)
      @.undelegateEvents()
      @.remove()
      window.cart.calculateSubtotal()
      # build condition to go back to flavors select view if you remove any flavors
      # if @.model.get('type') is 'flavor'
      #   debugger

    render: ->
      #throw in step from options arleady passed on line 327
      @.$el.html(@template(item: @model, step: this.options.step))
      


  Myapp.Views.ShoppingCartView = Backbone.View.extend
    initialize: ->
      @collection.bind('change', @render , @ )
      @collection.bind('add', @render , @ )
    typeList:
      type: ['plan','flavor','accessory']
    render: (event, type, step) ->
      if event
        @.collection.calculateSubtotal()
        type = event.get('type')
        step = @.typeList.type.indexOf(type) + 1
      $('#step-' + step + ' .items-container').empty()
      @collection.byType(type).each ((item) ->
        $('#step-' + step + ' .items-container').append new Myapp.Views.ItemCartView(model: item, step: step).render()
      ), this
      
      # each model
      # newItemCart = new Myapp.Views.ItemCartView(model: @.model)
      # $('#step-' + (@.typeList.type.indexOf(@model.get('type'))+1) + " .steps-header .items-container").html(@.$el)



      # something about binding add to item cart view, then remove the render shit
      # calculating totla price on add or remove as well
      # bind remove
      # renderCart
      # probably move the itemcartview render to here too and typelist
  
  $(document).on "click", ".steps-wrapper", ->
    if currentStep > $(this).data("step")
      currentStep = $(this).data("step")
      window.test.render()

  window.plans = new Myapp.Collections.Plans()
  window.accessories = new Myapp.Collections.Accessories()
  window.flavors = new Myapp.Collections.Flavors()
  plans.fetch()
  accessories.fetch()
  flavors.fetch()
  window.test = new Myapp.Views.StepView(collectionA: plans, collectionB: flavors, collectionC: accessories )

  window.cart = new Myapp.Collections.ShoppingCart()
  window.shoppingCartView = new Myapp.Views.ShoppingCartView(collection: window.cart)
  

  


