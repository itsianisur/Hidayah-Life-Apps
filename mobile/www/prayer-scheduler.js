// Hidayah Life - Android Prayer Notification Scheduler
// Powered by @capacitor/local-notifications

const APP_URL = 'https://hidayahlife.com';
const PRAYER_CITY = 'Dhaka';
const PRAYER_COUNTRY = 'Bangladesh';
const PRAYER_METHOD = 1; // 1 = Karachi / Hanafi

const PRAYER_INFO = [
  { key: 'Fajr', id: 101, body: 'এখন ফজরের সময়' },
  { key: 'Dhuhr', id: 102, body: 'এখন যোহরের সময়' },
  { key: 'Asr', id: 103, body: 'এখন আসরের সময়' },
  { key: 'Maghrib', id: 104, body: 'এখন মাগরিবের সময়' },
  { key: 'Isha', id: 105, body: 'এখন এশার সময়' },
];

let retryTimer = null;

function setStatus(msg) {
  const el = document.getElementById('status');
  if (el) el.textContent = msg;
}

// Check if Capacitor is available
function getLocalNotificationsPlugin() {
  if (window.Capacitor && window.Capacitor.Plugins && window.Capacitor.Plugins.LocalNotifications) {
    return window.Capacitor.Plugins.LocalNotifications;
  }
  return null;
}

async function requestPermissionsIfSupported() {
  const ln = getLocalNotificationsPlugin();
  if (ln && ln.requestPermissions) {
    try {
      const perm = await ln.requestPermissions();
      console.log('Notification permission status:', perm);
    } catch (err) {
      console.warn('Error requesting permissions:', err);
    }
  }
}

async function schedulePrayerAlerts(timings) {
  const ln = getLocalNotificationsPlugin();
  if (!ln) {
    console.log('Capacitor LocalNotifications plugin not detected in current environment.');
    return;
  }

  const now = new Date();
  const notificationsToSchedule = [];

  for (const prayer of PRAYER_INFO) {
    const rawTime = timings[prayer.key];
    if (!rawTime) continue;

    const cleanTime = rawTime.split(' ')[0];
    const [hours, minutes] = cleanTime.split(':').map(Number);

    const prayerDate = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      hours,
      minutes,
      0,
      0
    );

    if (prayerDate.getTime() > now.getTime()) {
      notificationsToSchedule.push({
        title: 'Hidayah Life',
        body: prayer.body,
        id: prayer.id,
        schedule: { at: prayerDate, allowWhileIdle: true },
        sound: 'beep.wav',
        smallIcon: 'ic_stat_icon',
        iconColor: '#D4A03E',
      });
      console.log(`Scheduling ${prayer.key} at ${cleanTime}`);
    }
  }

  if (notificationsToSchedule.length > 0) {
    try {
      // Clear previous today IDs first
      const idsToCancel = PRAYER_INFO.map((p) => ({ id: p.id }));
      await ln.cancel({ notifications: idsToCancel });
      await ln.schedule({ notifications: notificationsToSchedule });
      console.log(`Successfully scheduled ${notificationsToSchedule.length} prayer alerts.`);
    } catch (e) {
      console.error('Failed to schedule local notifications:', e);
    }
  }
}

async function fetchPrayerTimes() {
  const apiUrl = `https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(
    PRAYER_CITY
  )}&country=${encodeURIComponent(PRAYER_COUNTRY)}&method=${PRAYER_METHOD}`;

  try {
    const res = await fetch(apiUrl);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data && data.data && data.data.timings) {
      await schedulePrayerAlerts(data.data.timings);
      return true;
    }
    throw new Error('Invalid JSON structure');
  } catch (err) {
    console.warn('Network offline or prayer API failed, will retry in 15 mins:', err.message);
    scheduleRetry();
    return false;
  }
}

function scheduleRetry() {
  if (retryTimer) clearTimeout(retryTimer);
  retryTimer = setTimeout(() => {
    fetchPrayerTimes();
  }, 15 * 60 * 1000);
}

function scheduleNextMidnightCheck() {
  const now = new Date();
  const tomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 0, 1, 0);
  const ms = tomorrow.getTime() - now.getTime();

  setTimeout(() => {
    fetchPrayerTimes();
    scheduleNextMidnightCheck();
  }, ms);
}

// App Initialization
async function init() {
  setStatus('নামাজের সময়সূচি সমন্বয় করা হচ্ছে...');
  await requestPermissionsIfSupported();
  await fetchPrayerTimes();
  scheduleNextMidnightCheck();

  setStatus('ওয়েবসাইটে সংযুক্ত হচ্ছে...');
  setTimeout(() => {
    // Navigate to live web platform
    window.location.href = APP_URL;
  }, 600);
}

window.addEventListener('DOMContentLoaded', init);
