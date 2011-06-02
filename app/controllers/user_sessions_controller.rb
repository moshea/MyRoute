class UserSessionsController < ApplicationController
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    logger.debug("/user_session/new params: #{params.inspect}")
		@redirect = { :url => params[:url] }
		
    respond_to do |format|
      format.html{ render(:action => "new") } 
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    logger.debug("/user_session/create: params: #{params.inspect}")
		redirect_url = params[:user_session][:url] || root_url
		
    respond_to do |format|
      if @user_session.save
        format.html { redirect_to(redirect_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
end
