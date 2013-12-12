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
  Myapp = window.Myapp or {};
  
  # Myapp.Models.Items = Backbone.Model.extend
  #   defaults:
  #     name: Unknown Item
  #     image: ''

  Myapp.Models.flavor = Backbone.Model.extend
    defaults: 
      name: 'Unknown Product'
      image: ''

  Myapp.Collections.flavors = Backbone.Collection.extend
    model: Myapp.Models.flavor
    url: '/flavors'
      

  Myapp.Models.plan = Backbone.Model.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      level: ''

  Myapp.Collections.plans = Backbone.Collection.extend
    model: Myapp.Models.plan
    url: '/plans'

  Myapp.Models.accessory = Backbone.Model.extend
    defaults: 
      name: 'Unknown Product'
      cost: 0
      image: ''

  Myapp.Collections.accessories = Backbone.Collection.extend
    model: Myapp.Models.accessory
    url: '/accessories'
    productType: 'accessories'

  # Myapp.planView = Backbone.View.extend
  #     el: '#step-1 .steps-content'
  #     tagName: 'div'
  #     className: 'productContainer'
  #     events:
  #       'click .delete' : 'renderForm'
  #     template: JST['backbone/templates/planTemplate']
  #     renderForm: -> 
  #       view2 = new Myapp.formView
  #       view2.render()
  #     render: -> 
  #         @.$el.html( @.template( @.model.toJSON() ) );
  #         return @

  Myapp.Views.itemListView = Backbone.View.extend
      initialize: (options) ->
        _.bindAll()
        @collection.bind('reset', @render , @ )
        @.template = JST[options.templatePath]

      stepsList: 
        steps: ['plans','flavors','accessories', 'forms']
      tagName: 'div'
      className: 'planContainer'
      events:
        'click .continue' : 'nextStep'
        'click .form-continue' : 'nextForm'
      nextStep: ->
        if (window[@.stepsList.steps[@.options.currentStep]])
          window[@.stepsList.steps[@.options.currentStep]].fetch({reset: true})
          test = new Myapp.Views.itemListView(collection: window[@.stepsList.steps[@.options.currentStep]], el: '#step-' + (@.options.currentStep+1) + ' .steps-content', templatePath: 'backbone/templates/'+@.stepsList.steps[@.options.currentStep]+'Template', currentStep: @.options.currentStep+1)
      nextForm: ->
        test = new Myapp.Views.formView()
        test.render()
      render: ->
        @.$el.html( @.template( collection: @.collection.toJSON() ) );
        return @

  Myapp.Views.formView = Backbone.View.extend
      el: '#step-4 .steps-content'
      tagName: 'div'
      className: 'formContainer'
      template: JST['backbone/templates/form']
      render: -> 
          @.$el.html( @.template() );
          return @


  window.plans = new Myapp.Collections.plans()
  window.accessories = new Myapp.Collections.accessories()
  window.flavors = new Myapp.Collections.flavors()
  plans.fetch()
  test = new Myapp.Views.itemListView(collection: plans, el: '#step-1 .steps-content', currentStep: 1, templatePath: 'backbone/templates/plansTemplate')

  # Myapp.productView = Backbone.View.extend
  #     initialize: ->
  #       @collection.bind('reset', @render , @ )
  #     el: '#step-2 .steps-content'
  #     tagName: 'div'
  #     className: 'productContainer'
  #     events:
  #       'click .delete' : 'renderForm'
  #     template: JST['backbone/templates/productTemplate']
  #     renderForm: -> 
  #       view2 = new Myapp.formView
  #       view2.render()
  #     render: ->
  #       @.$el.html( @.template( collection: @.collection.toJSON() ) );
  #       return @


