// Configuration for Hidayah Life App Downloads
// Set your GitHub repository owner below.

export interface DownloadPlatformConfig {
  id: 'macos' | 'windows' | 'android';
  name: string;
  nameBn: string;
  filename: string;
  sizeEstimate: string;
  systemRequirements: string;
  systemRequirementsBn: string;
  downloadUrl: string;
}

export interface AppDownloadConfig {
  githubOwner: string; // TODO: Replace with the actual GitHub organization or username (e.g., 'anisurrahman')
  repoName: string;
  currentVersion: string;
  releaseDate: string;
  platforms: {
    macos: DownloadPlatformConfig;
    windows: DownloadPlatformConfig;
    android: DownloadPlatformConfig;
  };
  githubRepoUrl: string;
  releasesUrl: string;
}

// TODO: Update `githubOwner` with your GitHub username or organization
export const GITHUB_OWNER = 'itsianisur';
export const REPO_NAME = 'Hidayah-Life-Apps';
export const CURRENT_APP_VERSION = '1.0.0';

const BASE_RELEASE_URL = `https://github.com/${GITHUB_OWNER}/${REPO_NAME}/releases/latest/download`;

export const APP_DOWNLOAD_CONFIG: AppDownloadConfig = {
  githubOwner: GITHUB_OWNER,
  repoName: REPO_NAME,
  currentVersion: CURRENT_APP_VERSION,
  releaseDate: 'October 2026',
  githubRepoUrl: `https://github.com/${GITHUB_OWNER}/${REPO_NAME}`,
  releasesUrl: `https://github.com/${GITHUB_OWNER}/${REPO_NAME}/releases/latest`,
  platforms: {
    macos: {
      id: 'macos',
      name: 'macOS',
      nameBn: 'ম্যাক (macOS)',
      filename: 'Hidayah-Life-macOS.dmg',
      sizeEstimate: '~95 MB',
      systemRequirements: 'macOS 12.0+ (Apple Silicon & Intel 64-bit)',
      systemRequirementsBn: 'macOS ১২+ (অ্যাপল সিলিকন ও ইন্টেল প্রসেসর)',
      downloadUrl: `${BASE_RELEASE_URL}/Hidayah-Life-macOS.dmg`,
    },
    windows: {
      id: 'windows',
      name: 'Windows',
      nameBn: 'উইন্ডোজ (Windows)',
      filename: 'Hidayah-Life-Windows-Setup.exe',
      sizeEstimate: '~75 MB',
      systemRequirements: 'Windows 10 / 11 (64-bit)',
      systemRequirementsBn: 'উইন্ডোজ ১০ ও ১১ (৬৪-বিট)',
      downloadUrl: `${BASE_RELEASE_URL}/Hidayah-Life-Windows-Setup.exe`,
    },
    android: {
      id: 'android',
      name: 'Android',
      nameBn: 'অ্যান্ড্রয়েড (Android)',
      filename: 'Hidayah-Life-Android.apk',
      sizeEstimate: '~15 MB',
      systemRequirements: 'Android 8.0+ (Oreo or newer)',
      systemRequirementsBn: 'অ্যান্ড্রয়েড ৮.০+ (ওরিও বা পরবর্তী সংস্করণ)',
      downloadUrl: `${BASE_RELEASE_URL}/Hidayah-Life-Android.apk`,
    },
  },
};
