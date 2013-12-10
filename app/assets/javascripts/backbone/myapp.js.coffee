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
  
  Myapp.Models.product = Backbone.Model.extend
    defaults: 
      productName: 'Unknown Product'
      quantity: 0

  Myapp.Collections.products = Backbone.Collection.extend
      model: Myapp.Models.product
      url: '/items'

  # Myapp.plan = Backbone.Model.extend
  #   defaults: 
  #     planName: 'Unknown Plan'
    
      
  # Myapp.plans = Backbone.Collection.extend
  #     model: Myapp.plan

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
# @order.get('placements').on 'change', (e, a, b) =>
#         @submitBtn.attr('disabled', null).text("Submit Changes").addClass('btn-success')


  Myapp.productView = Backbone.View.extend
      initialize: ->
        @collection.bind('reset', @render , @ )
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
        @.$el.html( @.template( collection: @.collection.toJSON() ) );
        return @

  Myapp.formView = Backbone.View.extend
      el: '#step-3 .steps-content'
      tagName: 'div'
      className: 'formContainer'
      template: JST['backbone/templates/form']
      render: -> 
          @.$el.html( @.template() );
          return @

  products = new Myapp.Collections.products()
  products.fetch()
  test = new Myapp.productView(collection: products)

