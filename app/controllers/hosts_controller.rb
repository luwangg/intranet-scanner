class HostsController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @hosts = Host.page(params[:page]).per(30)
    @count = Host.count
    begin_time = Time.now
    @waste_time = Time.now - begin_time
  end

  def search
    begin_time = Time.now
    hosts_records = Host.search(
      size: 500,
      query: {
        multi_match: {
          query: params[:q].to_s,
          fields: ['server', 'title', 'ip', 'banner'],
          fuzziness: 1
        }
      }
    ).records
    @count = hosts_records.count
    @hosts=hosts_records.page(params[:page]).per(30)
    @waste_time = Time.now - begin_time

    render 'index'

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:ip, :port, :server, :banner, :title )
    end
end
