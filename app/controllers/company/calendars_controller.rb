class Company::CalendarsController < ApplicationController
  def index
    @calendar_events = company.calendars.where('start > ?', Date.today - 3.month)
  end

  # xhr
  def save
    if params[:id].present?
      @calendar = company.calendars.find(params[:id])
      @calendar.attributes = calendar_params
    else
      @calendar = company.calendars.new(calendar_params)
    end

    @calendar.staff = current_user

    if @calendar.save
    else
    end
  end

  def destroy
    render plain: params[:action]
  end

  private def calendar_params
    return @calendar_params if @calendar_params.present?
    p = params.require(:calendar).permit(
      'event_type',
      'title',
      'site_url',
      'allday',
      'start(1i)',
      'start(2i)',
      'start(3i)',
      'start(4i)',
      'start(5i)',
      'end(1i)',
      'end(2i)',
      'end(3i)',
      'end(4i)',
      'end(5i)',
    )

    @calendar_params = {
      event_type: p['event_type'],
      title: p['title'],
      site_url: p['site_url'],
      allday: p['allday'],
      start: DateTime.new(
        p['start(1i)'].to_i,
        p['start(2i)'].to_i,
        p['start(3i)'].to_i,
        p['start(4i)'].to_i,
        p['start(5i)'].to_i,
      ),
      end: DateTime.new(
        p['end(1i)'].to_i,
        p['end(2i)'].to_i,
        p['end(3i)'].to_i,
        p['end(4i)'].to_i,
        p['end(5i)'].to_i,
      ),
    }
  end
end
