class EventsController < ApplicationController
  
  before_filter :current_user, :require_user
  helper_method :sort_column, :sort_direction

  def index
    @events = current_user.events.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
  def all
    @events = current_user.events
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.json {
        render json: {
         :timeline => {
           :headline => "My Calendar",
           :type => "default",
           :startDate => "2013,04,01",
           :endDate => "2014,04,01",
           :date => @events,
           :asset => {
             :media => "http://www.example.com",
             :credit => "default",
             :caption => "default"
             }
           } 
         }
       }
    end
    
  end
  
  def show
    @event = current_user.events.find(params[:id])
    if params["modal"] == "true"
      render :template => "events/show_modal", :layout => false
    else
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @event }
      end

    end
  end

  def new
    @event = Event.new
    @event.attachments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
      format.json { render json: @event }
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.attachments.build
  end

  def create
    @event = Event.new(params[:event].merge(:user_id=>current_user.id))

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    
    respond_to do |format|
      if @event.update_attributes(params[:event].merge(:user_id => current_user.id))
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def reports
    report_start = Date.strptime(params[:event][:report_start],'%m/%d/%Y') if params[:event]
    report_end = Date.strptime(params[:event][:report_end],'%m/%d/%Y') if params[:event]
    if report_start && report_end
      @events = current_user.events.report(report_start, report_end)
    else
      @events = current_user.events.where(params[:search]).order(sort_column + " " + sort_direction)
    end
    
    respond_to do |format|
      format.html do
        @events = @events.paginate(:per_page => 5, :page => params[:page]) 
      end
      format.xml  { render :xml => @events }
      format.pdf do
        pdf = ReportPdf.new(@events)
        send_data pdf.render, filename: "Event_Report.pdf",
                              type: "application/pdf"
      end
    end
  end
  
  private
  
  def sort_column
    Event.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
