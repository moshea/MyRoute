class RoutesController < ApplicationController
	
	before_filter :authenticate, :only => [:new, :edit, :create, :update]
	# GET /routes
	# GET /routes.xml
	def index
		# default search terms will throw off the search, so remove them
		search_params = remove_default_search_terms(params[:search])
		logger.debug("routes search params: #{search_params.inspect}")
		@routes = Route.search(search_params).all

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @routes }
		end
	end

	# GET /routes/1
	# GET /routes/1.xml
	def show
		@route = Route.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @route }
		end
	end

	# GET /routes/new
	# GET /routes/new.xml
	def new
		logger.debug("/routes/new params[:route] : #{params[:route].inspect}")
		@route = Route.new(params[:route])
		@sports = Sport.all

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @route }
		end
	end

	# GET /routes/1/edit
	def edit
		@route = Route.find(params[:id])
		@sports = Sport.all
	end

	# POST /routes
	# POST /routes.xml
	def create
		@route = Route.new(params[:route].merge(:user=>current_user))
		@route.geocode
		
		respond_to do |format|
			if @route.save
				format.html { redirect_to(@route, :notice => 'Route was successfully created.') }
				format.xml  { render :xml => @route, :status => :created, :location => @route }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @route.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /routes/1
	# PUT /routes/1.xml
	def update
		@route = Route.find(params[:id])

		respond_to do |format|
			if @route.update_attributes(params[:route])
				format.html { redirect_to(@route, :notice => 'Route was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @route.errors, :status => :unprocessable_entity }
			end
		end
	end

	def overlay
		@route = Route.find(params[:id])
		respond_to do |format|
			format.json { render :text => @route.gmap_coords }
		end
	end
end
