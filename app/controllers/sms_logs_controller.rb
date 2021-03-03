class SmsLogsController < ApplicationController
  before_action :set_sms_log, only: [:show, :edit, :update, :destroy]

  # GET /sms_logs
  # GET /sms_logs.json
  def index
    @sms_logs = SmsLog.all
  end

  # GET /sms_logs/1
  # GET /sms_logs/1.json
  def show
  end

  # GET /sms_logs/new
  def new
    @sms_log = SmsLog.new
  end

  # GET /sms_logs/1/edit
  def edit
  end

  # POST /sms_logs
  # POST /sms_logs.json
  def create
    @sms_log = SmsLog.new(sms_log_params)

    respond_to do |format|
      if @sms_log.save
        format.html { redirect_to @sms_log, notice: 'Sms log was successfully created.' }
        format.json { render :show, status: :created, location: @sms_log }
      else
        format.html { render :new }
        format.json { render json: @sms_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sms_logs/1
  # PATCH/PUT /sms_logs/1.json
  def update
    respond_to do |format|
      if @sms_log.update(sms_log_params)
        format.html { redirect_to @sms_log, notice: 'Sms log was successfully updated.' }
        format.json { render :show, status: :ok, location: @sms_log }
      else
        format.html { render :edit }
        format.json { render json: @sms_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_logs/1
  # DELETE /sms_logs/1.json
  def destroy
    @sms_log.destroy
    respond_to do |format|
      format.html { redirect_to sms_logs_url, notice: 'Sms log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_log
      @sms_log = SmsLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sms_log_params
      params.fetch(:sms_log, {})
    end
end
