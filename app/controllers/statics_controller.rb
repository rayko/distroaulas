class StaticsController < ApplicationController
  respond_to :html


  def index

  end

  def view_doc
    respond_with do |format|
      format.html do
        if File.exists? Rails.root.join('app/views/statics', I18n.locale.to_s, params[:category], "_#{params[:doc]}.html.haml")
          render :partial => ['statics', I18n.locale, params[:category], params[:doc]].join('/')
        else
          render :partial => 'not_found'
        end
      end
    end
  end
end
