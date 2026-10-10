const { app, BrowserWindow, Menu, shell, Notification, dialog } = require('electron');
const path = require('path');
const fs = require('fs');

// ==========================================
// App Configuration & Prayer Defaults
// ==========================================
const APP_URL = 'https://hidayahlife.com';
const PRAYER_CITY = 'Dhaka';
const PRAYER_COUNTRY = 'Bangladesh';
const PRAYER_METHOD = 1; // 1 = University of Islamic Sciences, Karachi (Hanafi)
const ICON_PATH = path.join(__dirname, 'assets', 'icon.png');

// State
let mainWindow = null;
let prayerAlertsEnabled = true;
let activePrayerTimers = [];
let midnightTimer = null;
let retryTimer = null;

// Settings persistence
function getSettingsPath() {
  return path.join(app.getPath('userData'), 'settings.json');
}

function loadSettings() {
  try {
    const file = getSettingsPath();
    if (fs.existsSync(file)) {
      const data = JSON.parse(fs.readFileSync(file, 'utf8'));
      if (typeof data.prayerAlertsEnabled === 'boolean') {
        prayerAlertsEnabled = data.prayerAlertsEnabled;
      }
    }
  } catch (err) {
    console.error('Error loading settings:', err);
  }
}

function saveSettings() {
  try {
    const file = getSettingsPath();
    fs.writeFileSync(file, JSON.stringify({ prayerAlertsEnabled }, null, 2), 'utf8');
  } catch (err) {
    console.error('Error saving settings:', err);
  }
}

// ==========================================
// Single Instance Lock
// ==========================================
const gotSingleInstanceLock = app.requestSingleInstanceLock();
if (!gotSingleInstanceLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.show();
      mainWindow.focus();
    }
  });
}

// ==========================================
// Window Creation
// ==========================================
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    title: 'Hidayah Life',
    backgroundColor: '#041A13', // Deep emerald brand tone
    icon: ICON_PATH,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
    },
  });

  mainWindow.loadURL(APP_URL);

  // External links opened with target="_blank" must open in default system browser
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  // Catch non-app navigation to open in default browser
  mainWindow.webContents.on('will-navigate', (event, url) => {
    try {
      const targetUrl = new URL(url);
      const appUrl = new URL(APP_URL);
      if (targetUrl.origin !== appUrl.origin) {
        event.preventDefault();
        shell.openExternal(url);
      }
    } catch {
      // Allow relative or in-page transitions
    }
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  buildAppMenu();
}

// ==========================================
// Native Menu
// ==========================================
function buildAppMenu() {
  const isMac = process.platform === 'darwin';

  const template = [
    ...(isMac
      ? [
          {
            label: 'Hidayah Life',
            submenu: [
              {
                label: 'About Hidayah Life',
                click: () => {
                  dialog.showMessageBox(mainWindow, {
                    type: 'info',
                    title: 'About Hidayah Life',
                    message: 'Hidayah Life Desktop',
                    detail: 'Version 1.0.0\nFree-forever Islamic learning & networking platform.\nhttps://hidayahlife.com',
                    buttons: ['OK'],
                    icon: ICON_PATH,
                  });
                },
              },
              { type: 'separator' },
              { role: 'services' },
              { type: 'separator' },
              { role: 'hide' },
              { role: 'hideOthers' },
              { role: 'unhide' },
              { type: 'separator' },
              { role: 'quit' },
            ],
          },
        ]
      : []),
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' },
      ],
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' },
      ],
    },
    {
      label: 'Notifications',
      submenu: [
        {
          label: 'Prayer alerts',
          type: 'checkbox',
          checked: prayerAlertsEnabled,
          click: (menuItem) => {
            prayerAlertsEnabled = menuItem.checked;
            saveSettings();
            if (prayerAlertsEnabled) {
              fetchAndSchedulePrayerTimes();
            } else {
              clearPrayerTimers();
            }
          },
        },
        { type: 'separator' },
        {
          label: 'Test notification now',
          click: () => {
            triggerPrayerNotification('Hidayah Life', 'পরীক্ষামূলক নোটিফিকেশন: এখন নামাজের অ্যালার্ট সক্রিয় রয়েছে।');
          },
        },
        {
          label: 'Test notification in 2 minutes',
          click: () => {
            const in2Min = new Date(Date.now() + 2 * 60 * 1000);
            dialog.showMessageBox(mainWindow, {
              type: 'info',
              title: 'Test Scheduled',
              message: `২ মিনিটের মধ্যে পরীক্ষামূলক অ্যালার্ট আসবে (${in2Min.toLocaleTimeString('bn-BD')})।`,
              buttons: ['OK'],
            });
            setTimeout(() => {
              triggerPrayerNotification('Hidayah Life', 'পরীক্ষামূলক নোটিফিকেশন: ২ মিনিটের টেস্ট অ্যালার্ট সম্পন্ন হয়েছে।');
            }, 2 * 60 * 1000);
          },
        },
      ],
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'Visit Hidayah Life Website',
          click: () => shell.openExternal(APP_URL),
        },
        {
          label: 'GitHub Releases & Downloads',
          click: () => shell.openExternal('https://github.com/itsianisur/Hidayah-Life-Apps/releases/latest'),
        },
        ...(!isMac
          ? [
              { type: 'separator' },
              {
                label: 'About Hidayah Life',
                click: () => {
                  dialog.showMessageBox(mainWindow, {
                    type: 'info',
                    title: 'About Hidayah Life',
                    message: 'Hidayah Life Desktop',
                    detail: 'Version 1.0.0\nFree-forever Islamic learning & networking platform.\nhttps://hidayahlife.com',
                    buttons: ['OK'],
                    icon: ICON_PATH,
                  });
                },
              },
              { role: 'quit' },
            ]
          : []),
      ],
    },
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// ==========================================
// Prayer Time Notification Engine
// ==========================================
const PRAYER_TITLES = {
  Fajr: 'এখন ফজরের সময়',
  Dhuhr: 'এখন যোহরের সময়',
  Asr: 'এখন আসরের সময়',
  Maghrib: 'এখন মাগরিবের সময়',
  Isha: 'এখন এশার সময়',
};

function triggerPrayerNotification(title, body) {
  if (!Notification.isSupported()) {
    console.warn('System notifications are not supported on this platform.');
    return;
  }

  const notification = new Notification({
    title: title || 'Hidayah Life',
    body: body,
    icon: ICON_PATH,
    silent: false,
  });

  notification.on('click', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.show();
      mainWindow.focus();
    }
  });

  notification.show();
}

function clearPrayerTimers() {
  activePrayerTimers.forEach((timer) => clearTimeout(timer));
  activePrayerTimers = [];
}

function scheduleNextMidnightCheck() {
  if (midnightTimer) clearTimeout(midnightTimer);
  const now = new Date();
  const tomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 0, 1, 0); // 00:01 AM next day
  const msUntilMidnight = tomorrow.getTime() - now.getTime();

  midnightTimer = setTimeout(() => {
    console.log('Midnight reached: Re-scheduling daily prayer times...');
    fetchAndSchedulePrayerTimes();
    scheduleNextMidnightCheck();
  }, msUntilMidnight);
}

async function fetchAndSchedulePrayerTimes() {
  if (!prayerAlertsEnabled) {
    return;
  }

  clearPrayerTimers();
  if (retryTimer) clearTimeout(retryTimer);

  const apiUrl = `https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(
    PRAYER_CITY
  )}&country=${encodeURIComponent(PRAYER_COUNTRY)}&method=${PRAYER_METHOD}`;

  try {
    const res = await fetch(apiUrl, {
      headers: {
        'User-Agent': 'HidayahLife-Desktop/1.0',
      },
    });

    if (!res.ok) {
      console.warn(`Prayer API returned status ${res.status}, retrying in 15 mins.`);
      scheduleRetry();
      return;
    }

    const parsed = await res.json();
    if (parsed && parsed.data && parsed.data.timings) {
      console.log('Prayer timings fetched successfully for today:', parsed.data.timings);
      schedulePrayerAlerts(parsed.data.timings);
    } else {
      console.warn('Invalid prayer timings data structure, retrying in 15 mins.');
      scheduleRetry();
    }
  } catch (err) {
    console.warn('Network offline or prayer API unreachable, will retry in 15 mins:', err.message);
    scheduleRetry();
  }
}

function scheduleRetry() {
  // Retry after 15 minutes if offline or API failed; never crash.
  if (retryTimer) clearTimeout(retryTimer);
  retryTimer = setTimeout(() => {
    console.log('Retrying prayer times fetch...');
    fetchAndSchedulePrayerTimes();
  }, 15 * 60 * 1000);
}

function schedulePrayerAlerts(timings) {
  const now = new Date();
  const prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  prayerKeys.forEach((key) => {
    const timeStr = timings[key];
    if (!timeStr) return;

    // Aladhan format is "HH:mm" (24h) or "HH:mm (BST)"
    const cleanTime = timeStr.split(' ')[0];
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

    const msUntilPrayer = prayerDate.getTime() - now.getTime();

    if (msUntilPrayer > 0) {
      console.log(`Scheduled notification for ${key} in ${Math.round(msUntilPrayer / 60000)} minutes (${cleanTime}).`);
      const timer = setTimeout(() => {
        if (prayerAlertsEnabled) {
          triggerPrayerNotification('Hidayah Life', PRAYER_TITLES[key] || `এখন ${key}-এর সময়`);
        }
      }, msUntilPrayer);
      activePrayerTimers.push(timer);
    } else {
      console.log(`${key} (${cleanTime}) has already passed for today.`);
    }
  });
}

// ==========================================
// Lifecycle
// ==========================================
app.whenReady().then(() => {
  loadSettings();
  createWindow();

  // Initialize Prayer Alert engine
  fetchAndSchedulePrayerTimes();
  scheduleNextMidnightCheck();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
