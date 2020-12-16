class Company::CalendarsController < ApplicationController
  def index
  end

  # xhr
  def save
    if calendar_params['id'].present?
      @calendar = company.calendars.find(calendar_params['id'])
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
      'id',
      'event_type',
      'title',
      'url',
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
      'url',
    )

    @calendar_params = {
      id: p['id'],
      event_type: p['event_type'],
      title: p['title'],
      url: p['url'],
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
      url: p['url'],
    }
  end
end
