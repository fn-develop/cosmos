import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list';
import interactionPlugin, { Draggable } from '@fullcalendar/interaction';
import jaLocale from '@fullcalendar/core/locales/ja';
import '@fullcalendar/common/main.css';

require("izimodal");

$.fn.iziModal = iziModal;

$(function () {
  $('#calendar_modal').iziModal({
    headerColor: '#007BFF', //ヘッダー部分の色
    width: 768, //横幅
    zindex: 9999,
    fullscreen: true, //全画面表示
  });

  var calendarEl = document.getElementById('calendar');

  var calendar = new Calendar(calendarEl, {
    locale: jaLocale,
    slotDuration: '00:10:00', // 表示する時間軸の細かさ
    snapDuration: '00:10:00', // 選択する時間間隔
    plugins: [ dayGridPlugin, timeGridPlugin, interactionPlugin, listPlugin],
    headerToolbar: {
      left  : 'prev,next today',
      center: 'title',
      right : 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
    },
    initialView: 'dayGridMonth',
    events: calendar_events,
    weekends  : true, // 土曜、日曜を表示
    editable  : false,
    droppable : false, // ドラッグ変更
    dateClick: function(info) {
      $('#calendar_event_type').val('');
      $('#calendar_title').val('');
      $('#calendar_url').val('');
      $('#calendar_event_allday').prop('checked', false);
      $('#time_specification').addClass('d-none');

      let [year, month, day] = info.dateStr.split('-');
      $('#calendar_start_1i').val(year);
      $('#calendar_start_2i').val(month);
      $('#calendar_start_3i').val(day);
      $('#calendar_allday').prop('checked', false);
      $('.iziModal-header-title').text(info.dateStr);

      $('#calendar_modal').iziModal('open');
    },
    eventClick: function(info) {
      $('#calendar_modal').iziModal('open');
      // alert('Clicked on: ' + info.event.id);
      // alert('Event: ' + info.event.title);
      // alert('Coordinates: ' + info.jsEvent.pageX + ',' + info.jsEvent.pageY);
      // alert('View: ' + info.view.type);

      // change the border color just for fun
      // info.el.style.bordercolor = 'red';
    },
  });

  let event = new CustomEvent('add_event');
  document.addEventListener('add_event', function (e){
    //** format **//
    // calendar.addEvent({
    //   id             : 100000,
    //   title          : 'All Day Event',
    //   start          : '2020-12-01',
    //   backgroundcolor: '#f56954', //red
    //   bordercolor    : '#f56954', //red
    //   allday         : true
    // });
    calendar.addEvent(e.detail);
  }, true);

  calendar.render();

  // Date for the calendar events (dummy data)
  // var date = new Date()
  // var d    = date.getDate(),
  //     m    = date.getMonth(),
  //     y    = date.getFullYear()
  // {
  //   id             : 1,
  //   title          : 'All Day Event',
  //   start          : new Date(y, m, 1, 0, 0),
  //   backgroundcolor: '#f56954', //red
  //   bordercolor    : '#f56954', //red
  //   allday         : true
  // },
  // {
  //   id             : 2,
  //   title          : 'Long Event',
  //   start          : new Date(y, m, d - 5),
  //   end            : new Date(y, m, d - 2),
  //   backgroundcolor: '#f39c12', //yellow
  //   bordercolor    : '#f39c12' //yellow
  // },
  // {
  //   id             : 31,
  //   title          : 'Meeting',
  //   start          : new Date(y, m, d, 10, 30),
  //   allday         : false,
  //   backgroundcolor: '#0073b7', //Blue
  //   bordercolor    : '#0073b7' //Blue
  // },
  // {
  //   id             : 41,
  //   title          : 'Lunch',
  //   start          : new Date(y, m, d, 12, 0),
  //   end            : new Date(y, m, d, 14, 0),
  //   allday         : false,
  //   backgroundcolor: '#00c0ef', //Info (aqua)
  //   bordercolor    : '#00c0ef' //Info (aqua)
  // },
  // {
  //   id             : 51,
  //   title          : 'Birthday Party',
  //   start          : new Date(y, m, d + 1, 19, 0),
  //   end            : new Date(y, m, d + 1, 22, 30),
  //   allday         : false,
  //   backgroundcolor: '#00a65a', //Success (green)
  //   bordercolor    : '#00a65a' //Success (green)
  // },
  // {
  //   id             : 61,
  //   title          : 'Click for Google',
  //   start          : new Date(y, m, 28),
  //   end            : new Date(y, m, 29),
  //   url            : 'https://www.google.com/',
  //   backgroundcolor: '#3c8dbc', //Primary (light-blue)
  //   bordercolor    : '#3c8dbc' //Primary (light-blue)
  // }
})
