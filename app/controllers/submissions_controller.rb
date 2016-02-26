class SubmissionsController < ApplicationController
  # We won't enforce same-origin when checking authenticity
  self.forgery_protection_origin_check = false

  # Don't render layout if the request is XHR
  layout proc { false if request.xhr? }

  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  before_action :new_submission, only: [:new, :index, :create]
  before_action :all_submissions, only: [:new, :index, :create]

  after_action :all_submissions, only: [ :create ]
  after_action :new_submission, only: [ :create ]

  # GET /submissions
  # GET /submissions.json
  def index
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.js { }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.js { }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:word)
    end

    def new_submission
      @new_submission = @submission = Submission.new
    end

    def all_submissions
      @submissions = Submission.all
    end

    # This overrides a method found in
    # lib/action_controller/metal/request_forgery_protection.rb
    #
    # The method I'm overriding would not strip off the hostname and protocol
    # portion of the action_path, and when making my first request to the
    # remote server, the protocol and hostname would be part of the path but
    # then submitting the form back to the remote server would not include
    # the hostname and protocol and so the authenticity tokens would
    # appear different.
    #
    # I can't tell if this is a feature or a bug since I'm clearly trying to
    # do things via CORS that should not be done
    def normalize_action_path(action_path)
      logger.debug URI.parse(action_path).inspect
      URI.parse(action_path).path.to_s.chomp('/')
    end
end
