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

  Myapp.Views.StepView = Backbone.View.extend
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

    initialize: (options) ->
      @.options = options
      if @collection
        @collection.bind('reset', @render , @ )
      else
        @template = options.template
      return @
    template: JST['backbone/templates/stepsTemplate']
    render: ->
      @.$el.html( @.template(currentStep: currentStep) )
      @collection.each ((item) ->
        @$(".products-container").append new Myapp.Views.ItemView(model: item).render()
      ), this

      $('#step-' + (currentStep)).after(@.$el)
      return @
    renderForm: ->
      debugger
      @.$el.html( @.template( currentStep: currentStep) )
      $('#step-' + (currentStep)).after(@.$el)


  # Myapp.Views.itemListView = Backbone.View.extend
  #     initialize: (options) ->
  #       @collection.bind('reset', @render , @ )
  #       @.template = JST[options.templatePath]
  #     el: '.steps-content'
  #     stepsList: 
  #       steps: ['plans','flavors','accessories', 'form', 'stripe']
  #     tagName: 'div'
  #     events:
  #       'click .continue' : 'nextStep'
  #       'click .form-continue' : 'nextForm'
  #       'click .back' : 'backStep'
  #     backStep: ->
  #       if (window[@.stepsList.steps[@.options.currentStep-2]])
  #         window[@.stepsList.steps[@.options.currentStep-2]].fetch({reset: true})
  #         test = new Myapp.Views.itemListView(collection: window[@.stepsList.steps[@.options.currentStep-2]], templatePath: 'backbone/templates/'+@.stepsList.steps[@.options.currentStep-2]+'Template', currentStep: @.options.currentStep-1)
  #     nextStep: ->
  #       if (window[@.stepsList.steps[@.options.currentStep]])
  #         window[@.stepsList.steps[@.options.currentStep]].fetch({reset: true})
  #         test = new Myapp.Views.itemListView(collection: window[@.stepsList.steps[@.options.currentStep]], templatePath: 'backbone/templates/'+@.stepsList.steps[@.options.currentStep]+'Template', currentStep: @.options.currentStep+1)
  #     # nextForm: ->
  #     #   test = new Myapp.Views.formView()
  #     #   test.render()
  #     renderForm: ->
  #       @.$el.html( @.template() )
  #       $('#step-' + (@.options.currentStep)).after(@.$el)
  #       return @
  #     render: ->
  #       @.$el.html( @.template( collection: @.collection.toJSON() ) )
  #       $('#step-' + (@.options.currentStep)).after(@.$el)
  #       return @

  # Myapp.Views.formView = Backbone.View.extend
  #     el: '.steps-content'
  #     tagName: 'div'
  #     template: JST['backbone/templates/form']
  #     events:
  #       'click .form-continue' : 'nextForm'
  #       'click .back' : 'backForm'
  #     backForm: ->
  #       window['accessories'].fetch({reset: true})
  #       test = new Myapp.Views.itemListView(collection: window['accessories'], templatePath: 'backbone/templates/accessoriesTemplate', currentStep: 3)
  #     nextForm: ->
  #       test = new Myapp.Views.checkoutView()
  #       test.render()
  #     render: -> 
  #       @.$el.html( @.template() );
  #       $('#step-4').after(@.$el)
  #       return @

  # Myapp.Views.checkoutView = Backbone.View.extend
  #     el: '.steps-content'
  #     tagName: 'div'
  #     template: JST['backbone/templates/checkout']
  #     events:
  #       'click .form-continue' : 'nextForm'
  #       'click .back-form' : 'backForm'
  #     backForm: ->
  #       test = new Myapp.Views.formView()
  #       test.render()
  #     nextForm: ->
  #       test = new Myapp.Views.checkoutView()
  #       test.render()
  #     render: -> 
  #         @.$el.html( @.template() );
  #         $('#step-5').after(@.$el)
  #         return @


  window.plans = new Myapp.Collections.Plans()
  window.accessories = new Myapp.Collections.Accessories()
  window.flavors = new Myapp.Collections.Flavors()
  plans.fetch()
  test = new Myapp.Views.StepView(collection: plans)


