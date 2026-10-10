'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { APP_DOWNLOAD_CONFIG } from '@/lib/app-download';

export default function AppDownloadPage() {
  const [detectedOS, setDetectedOS] = useState<'macos' | 'windows' | 'android' | 'ios' | 'other'>('other');
  const [activeTab, setActiveTab] = useState<'macos' | 'windows' | 'android'>('macos');

  useEffect(() => {
    if (typeof window === 'undefined') return;
    const ua = navigator.userAgent.toLowerCase();

    if (/iphone|ipad|ipod/.test(ua)) {
      setDetectedOS('ios');
    } else if (/android/.test(ua)) {
      setDetectedOS('android');
      setActiveTab('android');
    } else if (/macintosh|mac os x/.test(ua)) {
      setDetectedOS('macos');
      setActiveTab('macos');
    } else if (/windows|win32|win64/.test(ua)) {
      setDetectedOS('windows');
      setActiveTab('windows');
    }
  }, []);

  return (
    <div className="min-h-screen bg-[#041A13] text-[#F3EFE0] selection:bg-[#E8B85A]/30 selection:text-[#FFF3D1] font-sans antialiased">
      {/* Background Islamic Geometric Glow */}
      <div className="fixed inset-0 pointer-events-none opacity-20">
        <div className="absolute top-[-10%] left-1/2 -translate-x-1/2 w-[800px] h-[600px] bg-gradient-to-b from-[#146049] to-transparent rounded-full blur-3xl" />
        <div className="absolute top-[35%] right-[-10%] w-[500px] h-[500px] bg-[#0B3D2E] rounded-full blur-3xl" />
      </div>

      <div className="relative z-10 max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-20">
        
        {/* Navigation Breadcrumb */}
        <div className="flex items-center space-x-2 text-sm text-[#A3C9B8] mb-8">
          <Link href="/" className="hover:text-[#E8B85A] transition-colors">হোম</Link>
          <span>/</span>
          <span className="text-[#FFF3D1] font-medium">অ্যাপ ডাউনলোড</span>
        </div>

        {/* =========================================================================
            C1. Hero Section
        ========================================================================= */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full border border-[#D4A03E]/40 bg-[#0B3D2E]/60 text-xs text-[#FFF3D1] mb-6 backdrop-blur-md shadow-inner">
            <span className="w-2 h-2 rounded-full bg-[#E8B85A] animate-ping" />
            <span className="font-semibold text-[#E8B85A]">সংস্করণ {APP_DOWNLOAD_CONFIG.currentVersion}</span>
            <span className="text-[#A3C9B8]">·</span>
            <span>১০০% ফ্রি ওপেন-সোর্স ডিস্ট্রিবিউশন</span>
          </div>

          <h1 className="text-3xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white mb-6 leading-tight">
            Hidayah Life <span className="bg-gradient-to-r from-[#FFF3D1] via-[#E8B85A] to-[#D4A03E] bg-clip-text text-transparent">অ্যাপ ডাউনলোড</span>
          </h1>

          <p className="text-lg sm:text-xl text-[#A3C9B8] leading-relaxed mb-10">
            পুরো প্ল্যাটফর্ম এখন আপনার ডিভাইসে — ফ্রি, কোনো অ্যাকাউন্ট লাগে না। ৫ ওয়াক্ত নামাজের সরাসরি অ্যালার্টসহ সবসময় আপ-টু-ডেট থাকুন।
          </p>

          {/* Three Main Download Buttons */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
            
            {/* macOS Button */}
            <a
              id="download-macos-btn"
              href={APP_DOWNLOAD_CONFIG.platforms.macos.downloadUrl}
              className={`relative group flex flex-col items-center justify-center p-6 rounded-2xl border transition-all duration-300 shadow-xl ${
                detectedOS === 'macos'
                  ? 'bg-gradient-to-b from-[#146049] to-[#0B3D2E] border-[#E8B85A] ring-2 ring-[#E8B85A]/50 scale-[1.02]'
                  : 'bg-[#06241B]/90 hover:bg-[#0B3D2E] border-[#184E3D] hover:border-[#E8B85A]/60'
              }`}
            >
              {detectedOS === 'macos' && (
                <span className="absolute -top-3 px-3 py-0.5 rounded-full text-[11px] font-bold bg-[#E8B85A] text-[#041A13] uppercase tracking-wider shadow">
                  আপনার জন্য
                </span>
              )}
              <div className="w-12 h-12 mb-3 text-[#FFF3D1] group-hover:text-[#E8B85A] transition-colors flex items-center justify-center">
                {/* Apple SVG */}
                <svg className="w-9 h-9 fill-current" viewBox="0 0 170 170">
                  <path d="M150.37 130.25c-2.45 5.66-5.35 10.87-8.71 15.66-4.58 6.53-8.33 11.05-11.22 13.56-4.48 4.12-9.28 6.23-14.42 6.35-3.69 0-8.14-1.05-13.32-3.18-5.19-2.12-9.97-3.17-14.34-3.17-4.58 0-9.49 1.05-14.75 3.17-5.26 2.13-9.5 3.24-12.74 3.35-4.35.13-9.16-1.9-14.42-6.08-3.69-3.04-7.67-7.81-11.96-14.3-5.75-8.7-10.32-18.7-13.72-30.01-3.4-11.31-5.1-22.35-5.1-33.12 0-14.79 3.73-27.18 11.2-37.16 7.47-9.98 17.03-15.14 28.69-15.48 5.68 0 11.75 1.55 18.23 4.67 6.47 3.12 10.42 4.73 11.83 4.83 1.74-.1 5.92-1.74 12.54-4.92 6.63-3.18 12.55-4.63 17.77-4.35 13.48.65 24.16 5.66 32.05 15.03-11.74 7.07-17.48 16.97-17.21 29.7.27 9.9 4.13 18.22 11.58 24.96 4.35 3.91 9.35 6.84 15.01 8.79-2.5 7.6-5.59 15.06-9.25 22.38zM119.22 31.84c0-7.39 2.66-14.42 7.98-21.09 5.33-6.67 11.95-10.75 19.86-12.25 1.09 7.61-1.36 14.88-7.35 21.82-5.99 6.94-13.06 10.93-21.2 11.98-.32-.16-.62-.31-.9-.47-.19-1.28-.39-2.7-.39-3.99z" />
                </svg>
              </div>
              <span className="text-base font-bold text-white mb-0.5">Download for macOS</span>
              <span className="text-xs text-[#A3C9B8]">Universal (.dmg) · {APP_DOWNLOAD_CONFIG.platforms.macos.sizeEstimate}</span>
            </a>

            {/* Windows Button */}
            <a
              id="download-windows-btn"
              href={APP_DOWNLOAD_CONFIG.platforms.windows.downloadUrl}
              className={`relative group flex flex-col items-center justify-center p-6 rounded-2xl border transition-all duration-300 shadow-xl ${
                detectedOS === 'windows'
                  ? 'bg-gradient-to-b from-[#146049] to-[#0B3D2E] border-[#E8B85A] ring-2 ring-[#E8B85A]/50 scale-[1.02]'
                  : 'bg-[#06241B]/90 hover:bg-[#0B3D2E] border-[#184E3D] hover:border-[#E8B85A]/60'
              }`}
            >
              {detectedOS === 'windows' && (
                <span className="absolute -top-3 px-3 py-0.5 rounded-full text-[11px] font-bold bg-[#E8B85A] text-[#041A13] uppercase tracking-wider shadow">
                  আপনার জন্য
                </span>
              )}
              <div className="w-12 h-12 mb-3 text-[#FFF3D1] group-hover:text-[#E8B85A] transition-colors flex items-center justify-center">
                {/* Windows SVG */}
                <svg className="w-8 h-8 fill-current" viewBox="0 0 24 24">
                  <path d="M0 3.449L9.75 2.1v9.451H0m10.949-9.602L24 0v11.4H10.949M0 12.6h9.75v9.451L0 20.699M10.949 12.6H24V24l-13.051-1.8" />
                </svg>
              </div>
              <span className="text-base font-bold text-white mb-0.5">Download for Windows</span>
              <span className="text-xs text-[#A3C9B8]">Installer (.exe) · {APP_DOWNLOAD_CONFIG.platforms.windows.sizeEstimate}</span>
            </a>

            {/* Android Button */}
            <a
              id="download-android-btn"
              href={APP_DOWNLOAD_CONFIG.platforms.android.downloadUrl}
              className={`relative group flex flex-col items-center justify-center p-6 rounded-2xl border transition-all duration-300 shadow-xl ${
                detectedOS === 'android'
                  ? 'bg-gradient-to-b from-[#146049] to-[#0B3D2E] border-[#E8B85A] ring-2 ring-[#E8B85A]/50 scale-[1.02]'
                  : 'bg-[#06241B]/90 hover:bg-[#0B3D2E] border-[#184E3D] hover:border-[#E8B85A]/60'
              }`}
            >
              {detectedOS === 'android' && (
                <span className="absolute -top-3 px-3 py-0.5 rounded-full text-[11px] font-bold bg-[#E8B85A] text-[#041A13] uppercase tracking-wider shadow">
                  আপনার জন্য
                </span>
              )}
              <div className="w-12 h-12 mb-3 text-[#FFF3D1] group-hover:text-[#E8B85A] transition-colors flex items-center justify-center">
                {/* Android SVG */}
                <svg className="w-9 h-9 fill-current" viewBox="0 0 24 24">
                  <path d="M17.523 15.3414c-.5511 0-.9993-.4486-.9993-1.0003 0-.5517.4482-1.0003.9993-1.0003.5516 0 1 .4486 1 1.0003 0 .5517-.4484 1.0003-1 1.0003m-11.046 0c-.5511 0-.9993-.4486-.9993-1.0003 0-.5517.4482-1.0003.9993-1.0003.5516 0 1 .4486 1 1.0003 0 .5517-.4484 1.0003-1 1.0003m11.4045-6.02l1.9973-3.4592a.416.416 0 00-.1521-.5676.416.416 0 00-.5676.1521l-2.0223 3.503C15.5902 8.4114 13.8533 8.1 12 8.1c-1.8533 0-3.5902.3114-5.1367.8497L4.841 5.4467a.4161.4161 0 00-.5677-.1521.4157.4157 0 00-.1521.5676l1.9973 3.4592C2.6889 11.1867.3432 14.6589 0 18.761h24c-.3432-4.1021-2.6889-7.5743-6.1185-9.4396" />
                </svg>
              </div>
              <span className="text-base font-bold text-white mb-0.5">Download for Android</span>
              <span className="text-xs text-[#A3C9B8]">Direct APK (.apk) · {APP_DOWNLOAD_CONFIG.platforms.android.sizeEstimate}</span>
            </a>

          </div>

          {/* Subtext info & Secondary button */}
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 text-xs text-[#8CA397] mb-8">
            <span>সংস্করণ: {APP_DOWNLOAD_CONFIG.currentVersion}</span>
            <span className="hidden sm:inline">•</span>
            <span>সম্পূর্ণ ফ্রি · কোনো অ্যাকাউন্ট বাধ্যতামূলক নয়</span>
            <span className="hidden sm:inline">•</span>
            <a
              href={APP_DOWNLOAD_CONFIG.githubRepoUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1.5 text-[#E8B85A] hover:underline"
            >
              <svg className="w-3.5 h-3.5 fill-current" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              GitHub Repository
            </a>
          </div>

          {/* iPhone / iOS Note Info Box */}
          <div className="p-4 sm:p-5 rounded-xl border border-[#D4A03E]/30 bg-[#0B3D2E]/40 backdrop-blur-sm text-left flex items-start gap-3.5 shadow-md">
            <div className="w-8 h-8 rounded-lg bg-[#E8B85A]/10 text-[#E8B85A] flex items-center justify-center shrink-0 mt-0.5">
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
              </svg>
            </div>
            <div>
              <h2 className="text-sm font-semibold text-[#FFF3D1] mb-1">iPhone ব্যবহারকারী?</h2>
              <p className="text-xs sm:text-sm text-[#A3C9B8] leading-relaxed">
                Safari থেকে <span className="text-[#FFF3D1] font-semibold">Share</span> বাটনে চাপ দিয়ে <span className="text-[#FFF3D1] font-semibold">Add to Home Screen</span> চাপুন — এটি দ্রুত ওয়েব অ্যাপ (PWA) হিসেবে ইনস্টল হয়ে যাবে। Apple সরাসরি sideloaded অ্যাপ সমর্থন করে না, তবে PWA অ্যাপ হিসেবে সম্পূর্ণ মসৃণ কাজ করে।
              </p>
            </div>
          </div>
        </div>

        {/* =========================================================================
            CSS App Mockup Visual Showcase
        ========================================================================= */}
        <div className="max-w-4xl mx-auto mb-20">
          <div className="rounded-2xl border border-[#184E3D] bg-[#020E0A] p-3 sm:p-4 shadow-2xl relative overflow-hidden group">
            {/* Top Mockup Chrome Bar */}
            <div className="flex items-center justify-between pb-3 mb-3 border-b border-[#0B3D2E]">
              <div className="flex items-center space-x-2">
                <span className="w-3 h-3 rounded-full bg-[#EF4444]" />
                <span className="w-3 h-3 rounded-full bg-[#F59E0B]" />
                <span className="w-3 h-3 rounded-full bg-[#10B981]" />
                <span className="ml-3 text-xs font-mono text-[#8CA397]">Hidayah Life Desktop — https://hidayahlife.com</span>
              </div>
              <div className="hidden sm:flex items-center gap-2 text-xs text-[#E8B85A] bg-[#0B3D2E] px-2.5 py-1 rounded-md">
                <span>🕌 আযান অ্যালার্ট সক্রিয়</span>
              </div>
            </div>

            {/* Inner Content Mockup */}
            <div className="relative rounded-xl overflow-hidden bg-gradient-to-b from-[#06241B] to-[#041A13] p-6 sm:p-10 border border-[#0B3D2E]/80">
              <div className="flex flex-col md:flex-row items-center justify-between gap-6">
                <div>
                  <span className="px-2.5 py-1 rounded text-xs font-medium bg-[#146049] text-[#FFF3D1] mb-3 inline-block">
                    আজকের নামাজের সময়সূচি (ঢাকা)
                  </span>
                  <div className="grid grid-cols-5 gap-2 sm:gap-3 text-center mt-2">
                    {[
                      { name: 'ফজর', time: '০৪:৩৮' },
                      { name: 'যোহর', time: '১১:৪৫' },
                      { name: 'আসর', time: '০৩:০৮' },
                      { name: 'মাগরিব', time: '০৫:৩৭' },
                      { name: 'এশা', time: '০৬:৫২' },
                    ].map((item, idx) => (
                      <div key={idx} className="bg-[#041A13] border border-[#184E3D] rounded-lg p-2 sm:p-3">
                        <div className="text-[11px] text-[#A3C9B8]">{item.name}</div>
                        <div className="text-xs sm:text-sm font-bold text-[#E8B85A] mt-0.5">{item.time}</div>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="bg-[#0B3D2E]/80 border border-[#D4A03E]/40 rounded-xl p-4 sm:p-5 max-w-xs text-left shadow-lg">
                  <div className="flex items-center gap-2.5 mb-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-[#E8B85A]" />
                    <span className="text-xs font-bold text-white uppercase tracking-wider">ডেস্কটপ নোটিফিকেশন</span>
                  </div>
                  <p className="text-xs text-[#A3C9B8] leading-relaxed">
                    অ্যাপ বন্ধ থাকলেও ব্যাকগ্রাউন্ডে নামাজের সময় হলে আপনার ম্যাক বা উইন্ডোজ স্ক্রিনে স্বয়ংক্রিয় বাংলা অ্যালার্ট পৌঁছে যাবে।
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* =========================================================================
            C2. Step-by-Step Install Instructions (Bangla, per-OS tabs)
        ========================================================================= */}
        <div className="max-w-4xl mx-auto mb-20">
          <div className="text-center mb-10">
            <h2 className="text-2xl sm:text-3xl font-bold text-white mb-3">ইনস্টলেশন নির্দেশিকা</h2>
            <p className="text-sm sm:text-base text-[#A3C9B8]">
              আপনার অপারেটিং সিস্টেম বেছে নিয়ে সহজে ইনস্টল করুন
            </p>
          </div>

          {/* Tabs */}
          <div className="flex justify-center mb-8">
            <div className="inline-flex p-1.5 rounded-xl bg-[#06241B] border border-[#184E3D]">
              <button
                type="button"
                onClick={() => setActiveTab('macos')}
                className={`px-5 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'macos'
                    ? 'bg-[#E8B85A] text-[#041A13] font-bold shadow'
                    : 'text-[#A3C9B8] hover:text-white'
                }`}
              >
                macOS
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('windows')}
                className={`px-5 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'windows'
                    ? 'bg-[#E8B85A] text-[#041A13] font-bold shadow'
                    : 'text-[#A3C9B8] hover:text-white'
                }`}
              >
                Windows
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('android')}
                className={`px-5 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'android'
                    ? 'bg-[#E8B85A] text-[#041A13] font-bold shadow'
                    : 'text-[#A3C9B8] hover:text-white'
                }`}
              >
                Android
              </button>
            </div>
          </div>

          {/* Tab Content Boxes */}
          <div className="rounded-2xl border border-[#184E3D] bg-[#06241B]/80 p-6 sm:p-8 backdrop-blur-sm shadow-xl">
            {activeTab === 'macos' && (
              <div className="space-y-6">
                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">১</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">DMG ফাইল ডাউনলোড করুন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      উপরে দেওয়া <span className="text-[#FFF3D1] font-medium">Download for macOS</span> বাটনে ক্লিক করে <code className="text-xs bg-[#041A13] px-1.5 py-0.5 rounded text-[#E8B85A]">Hidayah-Life-macOS.dmg</code> ফাইলটি নামিয়ে নিন।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">২</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">Applications ফোল্ডারে টেনে দিন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      ডাউনলোড করা DMG ফাইলটি ডাবল ক্লিক করে খুলুন এবং <span className="text-[#FFF3D1] font-medium">Hidayah Life</span> আইকনটিকে টেনে ডানপাশের <span className="text-[#FFF3D1] font-medium">Applications</span> ফোল্ডারে রাখুন।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">৩</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">প্রথম চালু ও নিরাপত্তা অনুমতি (Gatekeeper)</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      প্রথমবার খোলার সময় অ্যাপটির ওপর <strong>Right Click (দ্বি-ক্লিক) → Open</strong> চাপুন এবং নিশ্চিত করতে <strong>Open</strong> সিলেক্ট করুন। অথবা আপনার ম্যাকের <strong>System Settings → Privacy & Security</strong>-তে গিয়ে নিচে <strong>Open Anyway</strong> বাটনে চাপ দিন।
                    </p>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'windows' && (
              <div className="space-y-6">
                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">১</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">ইনস্টলার ডাউনলোড করে চালান</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      <span className="text-[#FFF3D1] font-medium">Download for Windows</span> থেকে <code className="text-xs bg-[#041A13] px-1.5 py-0.5 rounded text-[#E8B85A]">Hidayah-Life-Windows-Setup.exe</code> ডাউনলোড শেষে ফাইলটিতে ডাবল ক্লিক করুন। কোনো অ্যাডমিন পারমিশনের প্রয়োজন নেই।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">২</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">Microsoft SmartScreen বার্তা অতিক্রম</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      যদি উইন্ডোজ <span className="text-[#FFF3D1] font-medium">"Windows protected your PC"</span> বার্তা দেখায়, তাহলে সাধারণ নিয়মে <strong>"More info"</strong>-তে ক্লিক করে <strong>"Run anyway"</strong> চাপুন।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">৩</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">Start Menu বা ডেস্কটপ থেকে খুলুন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      ইনস্টলেশন স্বয়ংক্রিয়ভাবে সম্পন্ন হবে এবং আপনার Start Menu ও ডেস্কেটপে Hidayah Life শর্টকাট তৈরি হবে।
                    </p>
                  </div>
                </div>
              </div>
            )}

            {activeTab === 'android' && (
              <div className="space-y-6">
                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">১</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">APK ফাইল ডাউনলোড করুন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      <span className="text-[#FFF3D1] font-medium">Download for Android</span> বাটনে চাপ দিয়ে <code className="text-xs bg-[#041A13] px-1.5 py-0.5 rounded text-[#E8B85A]">Hidayah-Life-Android.apk</code> ফাইলটি নামিয়ে ফাইল ম্যানেজারে ট্যাপ করুন।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">২</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">Unknown Apps অনুমতি অনুমোদন করুন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      অ্যান্ড্রয়েড যদি <span className="text-[#FFF3D1] font-medium">"Install unknown apps"</span> সংক্রান্ত সতর্কতা দেখায়, তবে Settings-এ গিয়ে আপনার ব্রাউজার বা ফাইল ম্যানেজারের জন্য <strong>Allow from this source</strong> চালু করুন।
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-4">
                  <span className="w-8 h-8 rounded-full bg-[#146049] text-[#E8B85A] font-bold flex items-center justify-center shrink-0">৩</span>
                  <div>
                    <h3 className="text-base font-semibold text-white">ইনস্টল নিশ্চিত করুন</h3>
                    <p className="text-sm text-[#A3C9B8] mt-1">
                      পপআপে <strong>Install</strong> চাপুন এবং ইনস্টল শেষে অ্যাপটি ওপেন করে নামাজের নোটিফিকেশন অনুমোদন করুন।
                    </p>
                  </div>
                </div>
              </div>
            )}

            {/* Transparency statement */}
            <div className="mt-8 pt-6 border-t border-[#184E3D] flex items-start gap-3 text-xs text-[#A3C9B8]">
              <svg className="w-5 h-5 text-[#E8B85A] shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              <p>
                <strong>কেন এই সতর্কতা দেখা যায়?</strong> Hidayah Life একটি অলাভজনক ও সম্পূর্ণ ফ্রি প্ল্যাটফর্ম। আমরা কোনো পেইড কমার্শিয়াল সাইনিং সার্টিফিকেট (অ্যাপল বছরে $৯৯, উইন্ডোজ $২০০+) ব্যবহার করি না। এই বিল্ডগুলো ১০০% ওপেন-সোর্স, স্বচ্ছ এবং ক্ষতিকারক কোডমুক্ত।
              </p>
            </div>
          </div>
        </div>

        {/* =========================================================================
            C3. Features & System Requirements
        ========================================================================= */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto mb-20">
          
          {/* Features Card */}
          <div className="rounded-2xl border border-[#184E3D] bg-[#06241B]/60 p-6 sm:p-8">
            <h3 className="text-lg font-bold text-white mb-5 flex items-center gap-2">
              <span className="text-[#E8B85A]">✦</span> অ্যাপের প্রধান বৈশিষ্ট্যসমূহ
            </h3>
            <ul className="space-y-3.5 text-sm text-[#A3C9B8]">
              <li className="flex items-start gap-2.5">
                <span className="text-[#E8B85A] font-bold">✓</span>
                <span><strong>নেটিভ উইন্ডো ও ডক আইকন:</strong> ব্রাউজারের ট্যাব ভিড়ের বাইরে আলাদা ফোকাসড পরিবেশ।</span>
              </li>
              <li className="flex items-start gap-2.5">
                <span className="text-[#E8B85A] font-bold">✓</span>
                <span><strong>৫ ওয়াক্তে নেটিভ নামাজের অ্যালার্ট:</strong> প্রতিদিন স্বয়ংক্রিয়ভাবে সঠিক সময়ে বাংলায় নোটিফিকেশন।</span>
              </li>
              <li className="flex items-start gap-2.5">
                <span className="text-[#E8B85A] font-bold">✓</span>
                <span><strong>সর্বদা আপ-টু-ডেট:</strong> প্ল্যাটফর্মের সব নতুন কোর্স ও আলোচনা সরাসরি লোড হয়।</span>
              </li>
              <li className="flex items-start gap-2.5">
                <span className="text-[#E8B85A] font-bold">✓</span>
                <span><strong>সহজ মেমোরি খরচ:</strong> অপ্রয়োজনীয় ব্যাকগ্রাউন্ড প্রসেস নেই, ব্যাটারি ও র্যাম সাশ্রয়ী।</span>
              </li>
            </ul>
          </div>

          {/* System Requirements Card */}
          <div className="rounded-2xl border border-[#184E3D] bg-[#06241B]/60 p-6 sm:p-8">
            <h3 className="text-lg font-bold text-white mb-5 flex items-center gap-2">
              <span className="text-[#E8B85A]">✦</span> সিস্টেম রিকোয়ারমেন্টস
            </h3>
            <div className="space-y-4 text-sm text-[#A3C9B8]">
              <div>
                <div className="text-white font-semibold">macOS</div>
                <div className="text-xs text-[#8CA397] mt-0.5">macOS 12.0 বা পরবর্তী (Apple Silicon M1/M2/M3/M4 ও Intel x86_64)</div>
              </div>
              <div>
                <div className="text-white font-semibold">Windows</div>
                <div className="text-xs text-[#8CA397] mt-0.5">Windows 10 ও Windows 11 (64-bit সংস্করণ)</div>
              </div>
              <div>
                <div className="text-white font-semibold">Android</div>
                <div className="text-xs text-[#8CA397] mt-0.5">Android 8.0 (Oreo) বা পরবর্তী যেকোনো সংস্করণ</div>
              </div>
              <div className="pt-2 text-xs text-[#E8B85A]">
                * লাইভ কন্টেন্ট লোড করার জন্য সক্রিয় ইন্টারনেট সংযোগ প্রয়োজন।
              </div>
            </div>
          </div>

        </div>

        {/* =========================================================================
            C3. FAQ (Bangla)
        ========================================================================= */}
        <div className="max-w-4xl mx-auto mb-16">
          <div className="text-center mb-10">
            <h2 className="text-2xl sm:text-3xl font-bold text-white mb-2">প্রায়শই জিজ্ঞাসিত প্রশ্ন (FAQ)</h2>
            <p className="text-sm text-[#A3C9B8]">অ্যাপ সম্পর্কিত সাধারণ প্রশ্নের উত্তর</p>
          </div>

          <div className="space-y-4">
            {[
              {
                q: 'অ্যাপটি কি সম্পূর্ণ ফ্রি?',
                a: 'হ্যাঁ, Hidayah Life প্ল্যাটফর্ম এবং সব প্ল্যাটফর্মের অ্যাপ আজীবন সম্পূর্ণ ফ্রি। কোনো পেইড সাবস্ক্রিপশন বা বিজ্ঞাপন নেই।',
              },
              {
                q: 'আমার ডিভাইসে আননোন ডেভেলপার ওয়ার্নিং কেন আসে?',
                a: 'আমরা পেইড সার্টিফিকেট অথোরিটির পরিবর্তে সরাসরি GitHub Releases-এর মাধ্যমে ফ্রি ডিস্ট্রিবিউশন করি। এটি কোনো ক্ষতিকর অ্যাপ নয়, ওপরের নির্দেশিকা অনুসরণ করে সহজেই ওপেন করা যায়।',
              },
              {
                q: 'অ্যাপটি কি সম্পূর্ণ অফলাইনে কাজ করে?',
                a: 'না। এটি সবসময় তাজা কন্টেন্ট পরিবেশন করতে লাইভ ওয়েবসাইট লোড করে, তাই ইন্টারনেট সংযোগ প্রয়োজন। তবে নামাজের সময়সূচি অফলাইনেও সংরক্ষিত থাকে।',
              },
              {
                q: 'অ্যাপ আপডেট করব কীভাবে?',
                a: 'নতুন ভার্সন রিলিজ হলে এই পেজ থেকেই সরাসরি নতুন ইনস্টলার ডাউনলোড করে আপডেট করে নিতে পারবেন।',
              },
              {
                q: 'গুগল প্লে স্টোর বা অ্যাপল অ্যাপ স্টোরে কি অ্যাপটি পাওয়া যাবে?',
                a: 'না, কোনো স্টোর বাধ্যবাধকতা ও বিধিনিষেধ ছাড়া সম্পূর্ণ স্বাধীনভাবে সরাসরি ব্যবহারের জন্য আমরা ওপেন ডিস্ট্রিবিউশন মডেল ব্যবহার করছি।',
              },
              {
                q: 'আইফোনে কীভাবে ব্যবহার করব?',
                a: 'আইফোনে Safari খুলে Share বাটন থেকে "Add to Home Screen" চাপলেই এটি হোমস্ক্রিন অ্যাপ হিসেবে নিখুঁতভাবে চলবে।',
              },
            ].map((faq, idx) => (
              <div key={idx} className="rounded-xl border border-[#184E3D] bg-[#06241B]/70 p-5">
                <h4 className="text-base font-semibold text-white mb-2">{faq.q}</h4>
                <p className="text-sm text-[#A3C9B8] leading-relaxed">{faq.a}</p>
              </div>
            ))}
          </div>
        </div>

      </div>
    </div>
  );
}
