import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.hidayahlife.app',
  appName: 'Hidayah Life',
  webDir: 'www',
  server: {
    url: 'https://hidayahlife.com',
    cleartext: false,
  },
  android: {
    allowMixedContent: false,
    backgroundColor: '#041A13',
  },
  plugins: {
    LocalNotifications: {
      smallIcon: 'ic_stat_icon',
      iconColor: '#D4A03E',
      sound: 'beep.wav',
    },
  },
};

export default config;
