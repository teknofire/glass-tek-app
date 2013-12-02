class NotificationsController < ApplicationController
  protect_from_forgery :except => [:push]
  
  before_filter :login_required!, except: [:push]
  
  def index
    @notifications = Notification.where(user_id: current_user.id)
  end
  
  def push
    @notification = Notification.from_param(params[:id])
    resp = Timeline.create(@notification.user, @notification.message)
    
    respond_to do |format|
      format.html {
        if resp.ok?
          flash[:success] = 'Notificaiton sent'
        else
          flash[:danger] = "Error while sending notification: #{Timeline.error}"
        end
      }
      format.json {
        render json: { success: resp.ok? }
      }
      format.xml {
        render xml: { success: resp.ok? }
      }
    end
  rescue NoGoogleApiTokenError => e
    flash[:warning] = "Could not find a valid mirror api token #{e}"
    redirect_to '/'
  rescue InvalidRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
    redirect_to '/'
  rescue NotAuthenticatedError => e
    logger.info e.inspect
    flash[:danger] = "Mirror api token is not authorized or has expired"
    redirect_to '/'
  rescue UnknownRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
    redirect_to '/'        
  end
  
  def new
    @notification = Notification.new
  end
  
  def create
    @notification = current_user.notifications.build(notification_params)
    
    respond_to do |format|
      if @notification.save
        format.html {
          flash[:success] = "New notification created"
          redirect_to @notification
        }
      else
        format.html {
          render :new
        }
      end
    end
  end
  
  def edit
    @notification = current_user.notifications.from_param(params[:id])
  end
  
  def update
    @notification = current_user.notifications.from_param(params[:id])
    respond_to do |format|
      if @notification.update_attributes(notification_params)
        format.html {
          flash[:success] = "Updated notification"
          redirect_to @notification
        }
      else
        format.html {
          render :edit
        }
      end
    end
  end
  
  def show
    @notification = current_user.notifications.from_param(params[:id])
  end
  
  def destroy
    @notification = current_user.notifications.from_param(params[:id])
    
    respond_to do |format|
      if @notification.destroy
        flash[:success] = "Notification deleted"
      else
        flash[:danger] = "Unable to delete the notification"          
      end
      
      format.html {
        redirect_to notifications_path
      }
    end
  end
  
  protected
  
  def notification_params
    params.require(:notification).permit(:name, :message)
  end
end
