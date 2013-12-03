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

  Myapp.Product = Backbone.Model.extend
    defaults: 
      productName: 'Unknown Product'
      quantity: 0
      
  Myapp.Products = Backbone.Collection.extend
      model: Myapp.Product


  Myapp.ProductView = Backbone.View.extend
      el: '#container'
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
      el: '#container'
      tagName: 'div'
      className: 'formContainer'
      template: JST['backbone/templates/form']
      render: -> 
          @.$el.html( @.template() );
          return @

  product = new Myapp.Product
  test = new Myapp.ProductView(model: product)
  test.render()