# coding: utf-8
class PagesController < ApplicationController
  def index
    @boroughs = Borough.fields(:name, :slug).sort(:name.asc).all
    @people = Person.sort(:last_name.asc).all
    @activities = Activity.sort(:published_at.desc).limit(40)

    respond_to do |format|
      format.html
      format.atom { head :no_content if @activities.empty? }
    end
  end

  def search
    if params[:q].blank?
      flash.alert = "Vous n'avez pas indiqué un code postal."
      redirect_to root_path
    else
      begin
        borough = Borough.find_by_postal_code(params[:q].gsub(/[^A-Za-z0-9]/, '').upcase)
        redirect_to borough_path(id: borough.slug)
      rescue MongoMapper::DocumentNotFound
        flash.alert = "Le code postal <strong>#{params[:q]}</strong> n'est pas recensé dans notre système. Assurez-vous d'avoir entré un code postal de la Ville de Montréal.".html_safe
        redirect_to root_path
      rescue Timeout::Error
        flash.alert = "Le site de la Ville de Montréal ne répond pas. S'il vous plaît réessayer."
        redirect_to root_path
      end
    end
  end
end
