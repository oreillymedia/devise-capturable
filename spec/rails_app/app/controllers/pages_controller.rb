class PagesController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    render text: "Index"
  end

  def protected
    render text: "Protected"
  end
end
