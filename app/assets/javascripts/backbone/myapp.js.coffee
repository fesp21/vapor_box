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
  Myapp = Myapp or {};

  Myapp.product = Backbone.Model.extend
    defaults: 
      productName: 'Unknown Product'
      quantity: 0
      
  Myapp.products = Backbone.Collection.extend
      model: Myapp.product

  Myapp.plan = Backbone.Model.extend
    defaults: 
      planName: 'Unknown Plan'
      
  Myapp.plans = Backbone.Collection.extend
      model: Myapp.plan

  Myapp.planView = Backbone.View.extend
      el: '#step-1 .steps-content'
      tagName: 'div'
      className: 'productContainer'
      events:
        'click .delete' : 'renderForm'
      template: JST['backbone/templates/planTemplate']
      renderForm: -> 
        view2 = new Myapp.formView
        view2.render()
      render: -> 
          @.$el.html( @.template( @.model.toJSON() ) );
          return @

  Myapp.productView = Backbone.View.extend
      el: '#step-2 .steps-content'
      tagName: 'div'
      className: 'productContainer'
      events:
        'click .delete' : 'renderForm'
      template: JST['backbone/templates/productTemplate']
      renderForm: -> 
        view2 = new Myapp.formView
        view2.render()
      render: -> 
          @.$el.html( @.template( @.model.toJSON() ) );
          return @

  Myapp.formView = Backbone.View.extend
      el: '#step-3 .steps-content'
      tagName: 'div'
      className: 'formContainer'
      template: JST['backbone/templates/form']
      render: -> 
          @.$el.html( @.template() );
          return @

  product = new Myapp.product
  test = new Myapp.productView(model: product)
  test.render()