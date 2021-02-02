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
    height: 'auto',
    slotMinTime: '07:00:00',
    slotMaxTime: '22:00:00',
    slotDuration: '00:10:00', // 表示する時間軸の細かさ
    snapDuration: '00:10:00', // 選択する時間間隔
    plugins: [ dayGridPlugin, timeGridPlugin, interactionPlugin, listPlugin],
    headerToolbar: {
      left  : 'prev',
      center: 'title',
      right : 'next'
    },
    //曜日のテキストを書き換えます（日〜土）
    initialView: 'listMonth',
    events: calendar_events,
    weekends  : true, // 土曜、日曜を表示
    editable  : false,
    droppable : false, // ドラッグ変更
    eventClick: function(info) {
      // カレンダー参加ユーザー情報を取得する為のイベントに着火
      document.dispatchEvent(new CustomEvent('show_event', { detail: info.event.id }));
      $('#calendar_joined_user_calendar_id').val(info.event.id);
      if(info.event.extendedProps.is_entry != undefined){
        $('#join_form').removeClass('d-none');
      } else {
        $('#join_form').addClass('d-none');
      }

      $('#calendar_title').text(info.event.title);

      if(info.event.extendedProps.memo != undefined){
        $('#calendar_memo').html(info.event.extendedProps.memo.replace(/\r?\n/g, '<br />'));
      } else {
        $('#calendar_memo').text('');
      }

      if(info.event.extendedProps.site_url != undefined){
        $('#calendar_url').attr('href', info.event.extendedProps.site_url);
        $('#calendar_url').text('サイト');
      } else {
        $('#calendar_url').attr('href', '#');
        $('#calendar_url').text('');
      }

      var range_str = '';

      var sdate = info.event.start;
      var sd    = sdate.getDate(),
          sm    = sdate.getMonth() + 1,
          sy    = sdate.getFullYear(),
          sh    = sdate.getHours(),
          smi   = sdate.getMinutes()

      sh  = ('0' + sh).slice(-2);
      smi = ('0' + smi).slice(-2);
      range_str += sy + '年';
      range_str += sm + '月';
      range_str += sd + '日 ';

      if(info.event.allDay == false) {
        range_str += sh + ':';
        range_str += smi;

        var edate = info.event.end;

        if(edate == null) {
          range_str += ' 開始';
        } else {
          var ed    = edate.getDate(),
              em    = edate.getMonth() + 1,
              ey    = edate.getFullYear(),
              eh    = edate.getHours(),
              emi   = edate.getMinutes()

          eh  = ('0' + eh).slice(-2);
          emi = ('0' + emi).slice(-2);
          range_str += ' 〜 ';
          if (ed != sd || em != sm || ey != sy) {
            range_str += ey + '年';
            range_str += em + '月';
            range_str += ed + '日 ';
          }
          range_str += eh + ':';
          range_str += emi;
        }
      }

      $('.iziModal-header-title').text(range_str);
      $('#calendar_modal').iziModal('open');
    },
  });

  calendar.render();
})
