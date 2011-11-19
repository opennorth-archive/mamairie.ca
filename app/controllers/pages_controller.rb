# coding: utf-8
class PagesController < ApplicationController
  def index
    @boroughs = Borough.fields(:name, :slug).all
    @people = Person.all
    # @todo activity feed
  end

  def search
    if params[:postal_code].blank?
      flash.alert = "Vous n'avez pas indiqué un code postal."
    else
      begin
        redirect_to Borough.find_by_postal_code(params[:postal_code].gsub(/[^A-Za-z0-9]/, '').upcase)
      rescue MongoMapper::DocumentNotFound
        flash.alert = "Ce code postal n'est pas recensé dans notre système. Assurez-vous d'avoir entré un code postal de la Ville de Montréal."
      rescue Timeout::Error
        flash.alert = "Le site de la Ville de Montréal ne répond pas. S'il vous plaît réessayer."
      end
    end
  end

  def about
    
  end
end
