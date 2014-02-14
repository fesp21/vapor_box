class StaticPagesController < ApplicationController

  before_filter :adult_check, :except => [:age_check]

  def home
  end

  def about
  end

  def how_it_works
  end

  def signup
  end

  def faq
  end

  def contact
  end

  def signup_wufoo
  end

  def products
  end

  def age_check
    render layout: 'without_nav'
  end

  
end
