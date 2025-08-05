class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user

  # POST /api/v1/users/:user_id/sleep_records
  def create
  end

  # GET  /api/v1/users/:user_id/sleep_records
  def index
  end

  # GET  /api/v1/users/:user_id/sleep_records/:id
  def show
  end

  # GET /api/v1/users/:user_id/sleep_records/friend_sleep_records
  def friend_sleep_records
  end
end
