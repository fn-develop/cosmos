class CalendarEvent
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id,              :string
  attribute :title,           :string, default: ''
  attribute :start,           :string
  attribute :end,             :string
  attribute :backgroundcolor, :string, default: '#f56954' #red
  attribute :bordercolor,     :string, default: '#f56954' #red
  attribute :allday,          :string, default: 'false'
  attribute :url,             :string
end
