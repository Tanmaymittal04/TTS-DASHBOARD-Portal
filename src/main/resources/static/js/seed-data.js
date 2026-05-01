/* ═══════════════════════════════════════════════════════════════
   seed-data.js — All hardcoded dashboard data (Phase 1)
   TTS Training Dashboard — Cyfuture AI
   Loaded globally in base.jsp before any page JS
════════════════════════════════════════════════════════════════ */

const SEED = {

  /* ── DATASETS ─────────────────────────────────────────────── */
  datasets: [
    { id:'ds_hi_001', name:'Hindi Female Support Dataset',    language:'Hindi',    langCode:'hi', accent:'North Indian',  source:'recorded',    sourceName:'Internal Recording', license:'approved', rawHours:120.5, cleanHours:87.2,  clips:42000, speakers:35, status:'approved',  assignedTo:'Ravi Kumar' },
    { id:'ds_en_001', name:'English Neutral Support Dataset', language:'English',  langCode:'en', accent:'Neutral',       source:'open_source', sourceName:'LibriSpeech',        license:'approved', rawHours:200.0, cleanHours:162.4, clips:68000, speakers:80, status:'training',  assignedTo:'Priya Singh' },
    { id:'ds_ta_001', name:'Tamil Male Sales Dataset',        language:'Tamil',    langCode:'ta', accent:'Chennai',       source:'vendor',      sourceName:'VoiceVendor Co.',    license:'approved', rawHours:80.0,  cleanHours:58.6,  clips:28000, speakers:22, status:'qc',        assignedTo:'Arjun Nair' },
    { id:'ds_kn_001', name:'Kannada Male Support Dataset',    language:'Kannada',  langCode:'kn', accent:'Bangalore',     source:'recorded',    sourceName:'Internal Recording', license:'pending',  rawHours:60.0,  cleanHours:41.2,  clips:18000, speakers:18, status:'intake',    assignedTo:'Sunita Rao' },
    { id:'ds_mr_001', name:'Marathi Female Collections',      language:'Marathi',  langCode:'mr', accent:'Pune',          source:'recorded',    sourceName:'Internal Recording', license:'approved', rawHours:75.0,  cleanHours:52.8,  clips:24000, speakers:20, status:'scored',    assignedTo:'Deepak Joshi' },
    { id:'ds_te_001', name:'Telugu Male Collections Dataset', language:'Telugu',   langCode:'te', accent:'Hyderabad',     source:'vendor',      sourceName:'AudioHub India',     license:'pending',  rawHours:55.0,  cleanHours:32.1,  clips:15000, speakers:15, status:'qc',        assignedTo:'Kavya Reddy' },
    { id:'ds_bn_001', name:'Bengali Female Support Dataset',  language:'Bengali',  langCode:'bn', accent:'Kolkata',       source:'open_source', sourceName:'OpenSLR',            license:'approved', rawHours:45.0,  cleanHours:31.4,  clips:14000, speakers:12, status:'approved',  assignedTo:'Amit Das' },
    { id:'ds_pa_001', name:'Punjabi Male Sales Dataset',      language:'Punjabi',  langCode:'pa', accent:'Amritsar',      source:'recorded',    sourceName:'Internal Recording', license:'rejected', rawHours:40.0,  cleanHours:0.0,   clips:0,     speakers:10, status:'rejected',  assignedTo:'Harpreet Kaur' },
    { id:'ds_gu_001', name:'Gujarati Neutral Support',        language:'Gujarati', langCode:'gu', accent:'Ahmedabad',     source:'vendor',      sourceName:'LinguaData',         license:'pending',  rawHours:50.0,  cleanHours:34.5,  clips:16000, speakers:14, status:'intake',    assignedTo:'Nikhil Patel' },
    { id:'ds_hi_002', name:'Hindi Male Collections Dataset',  language:'Hindi',    langCode:'hi', accent:'Delhi',         source:'recorded',    sourceName:'Internal Recording', license:'approved', rawHours:90.0,  cleanHours:68.9,  clips:32000, speakers:28, status:'training',  assignedTo:'Ravi Kumar' }
  ],

  /* ── AUDIO CLIPS (sample — 15 records) ───────────────────── */
  audioClips: [
    { id:'clip_hi_000001', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_hi_f_001', duration:6.4,  noiseScore:0.08, silenceRatio:0.12, clippingRatio:0.003, wer:0.06, qualityScore:87, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Anita' },
    { id:'clip_hi_000002', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_hi_f_001', duration:4.2,  noiseScore:0.22, silenceRatio:0.08, clippingRatio:0.001, wer:0.10, qualityScore:54, status:'fail',   rejectionReason:'high noise',    reviewedBy:'QC_Anita' },
    { id:'clip_hi_000003', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_hi_f_002', duration:7.1,  noiseScore:0.05, silenceRatio:0.10, clippingRatio:0.000, wer:0.04, qualityScore:92, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Anita' },
    { id:'clip_en_000001', datasetId:'ds_en_001', langCode:'en', speakerId:'spk_en_m_001', duration:5.8,  noiseScore:0.03, silenceRatio:0.07, clippingRatio:0.001, wer:0.03, qualityScore:95, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Rohan' },
    { id:'clip_en_000002', datasetId:'ds_en_001', langCode:'en', speakerId:'spk_en_m_002', duration:3.9,  noiseScore:0.04, silenceRatio:0.28, clippingRatio:0.000, wer:0.05, qualityScore:61, status:'review', rejectionReason:'high silence',  reviewedBy:'QC_Rohan' },
    { id:'clip_ta_000001', datasetId:'ds_ta_001', langCode:'ta', speakerId:'spk_ta_m_001', duration:8.2,  noiseScore:0.06, silenceRatio:0.09, clippingRatio:0.002, wer:0.04, qualityScore:89, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Priya' },
    { id:'clip_ta_000002', datasetId:'ds_ta_001', langCode:'ta', speakerId:'spk_ta_m_001', duration:2.1,  noiseScore:0.14, silenceRatio:0.11, clippingRatio:0.008, wer:0.08, qualityScore:48, status:'fail',   rejectionReason:'clipping',      reviewedBy:'QC_Priya' },
    { id:'clip_kn_000001', datasetId:'ds_kn_001', langCode:'kn', speakerId:'spk_kn_m_001', duration:5.5,  noiseScore:0.09, silenceRatio:0.13, clippingRatio:0.002, wer:0.07, qualityScore:78, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Suresh' },
    { id:'clip_mr_000001', datasetId:'ds_mr_001', langCode:'mr', speakerId:'spk_mr_f_001', duration:6.8,  noiseScore:0.11, silenceRatio:0.10, clippingRatio:0.001, wer:0.09, qualityScore:74, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Anita' },
    { id:'clip_te_000001', datasetId:'ds_te_001', langCode:'te', speakerId:'spk_te_m_001', duration:4.4,  noiseScore:0.19, silenceRatio:0.15, clippingRatio:0.004, wer:0.14, qualityScore:44, status:'fail',   rejectionReason:'high noise',    reviewedBy:'QC_Rohan' },
    { id:'clip_bn_000001', datasetId:'ds_bn_001', langCode:'bn', speakerId:'spk_bn_f_001', duration:7.3,  noiseScore:0.10, silenceRatio:0.08, clippingRatio:0.001, wer:0.08, qualityScore:81, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Priya' },
    { id:'clip_hi_000004', datasetId:'ds_hi_002', langCode:'hi', speakerId:'spk_hi_m_001', duration:5.9,  noiseScore:0.07, silenceRatio:0.11, clippingRatio:0.002, wer:0.05, qualityScore:88, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Suresh' },
    { id:'clip_en_000003', datasetId:'ds_en_001', langCode:'en', speakerId:'spk_en_f_001', duration:6.6,  noiseScore:0.04, silenceRatio:0.09, clippingRatio:0.000, wer:0.03, qualityScore:94, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Anita' },
    { id:'clip_hi_000005', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_hi_f_003', duration:3.8,  noiseScore:0.31, silenceRatio:0.06, clippingRatio:0.001, wer:0.18, qualityScore:38, status:'fail',   rejectionReason:'transcript mismatch', reviewedBy:'QC_Rohan' },
    { id:'clip_ta_000003', datasetId:'ds_ta_001', langCode:'ta', speakerId:'spk_ta_m_002', duration:9.1,  noiseScore:0.05, silenceRatio:0.10, clippingRatio:0.001, wer:0.03, qualityScore:93, status:'pass',   rejectionReason:null,            reviewedBy:'QC_Priya' }
  ],

  /* ── DATASET SCORES ───────────────────────────────────────── */
  datasetScores: [
    { id:'score_ds_hi_001', datasetId:'ds_hi_001', audioClarity:88, transcriptAccuracy:92, speakerConsistency:85, accentPurity:82, languagePurity:90, coverage:78, finalScore:87, recommendation:'approved_for_training' },
    { id:'score_ds_en_001', datasetId:'ds_en_001', audioClarity:94, transcriptAccuracy:96, speakerConsistency:91, accentPurity:88, languagePurity:95, coverage:84, finalScore:92, recommendation:'approved_for_training' },
    { id:'score_ds_ta_001', datasetId:'ds_ta_001', audioClarity:82, transcriptAccuracy:88, speakerConsistency:79, accentPurity:84, languagePurity:91, coverage:72, finalScore:83, recommendation:'approved_for_training' },
    { id:'score_ds_kn_001', datasetId:'ds_kn_001', audioClarity:74, transcriptAccuracy:78, speakerConsistency:71, accentPurity:76, languagePurity:83, coverage:64, finalScore:74, recommendation:'rework' },
    { id:'score_ds_mr_001', datasetId:'ds_mr_001', audioClarity:79, transcriptAccuracy:82, speakerConsistency:76, accentPurity:80, languagePurity:87, coverage:68, finalScore:79, recommendation:'rework' },
    { id:'score_ds_te_001', datasetId:'ds_te_001', audioClarity:61, transcriptAccuracy:65, speakerConsistency:58, accentPurity:70, languagePurity:75, coverage:55, finalScore:63, recommendation:'rejected' },
    { id:'score_ds_bn_001', datasetId:'ds_bn_001', audioClarity:80, transcriptAccuracy:84, speakerConsistency:78, accentPurity:79, languagePurity:88, coverage:70, finalScore:80, recommendation:'approved_for_training' },
    { id:'score_ds_hi_002', datasetId:'ds_hi_002', audioClarity:86, transcriptAccuracy:90, speakerConsistency:83, accentPurity:81, languagePurity:89, coverage:76, finalScore:85, recommendation:'approved_for_training' },
    { id:'score_ds_gu_001', datasetId:'ds_gu_001', audioClarity:72, transcriptAccuracy:76, speakerConsistency:69, accentPurity:74, languagePurity:81, coverage:62, finalScore:72, recommendation:'rework' },
    { id:'score_ds_pa_001', datasetId:'ds_pa_001', audioClarity:58, transcriptAccuracy:60, speakerConsistency:55, accentPurity:62, languagePurity:68, coverage:50, finalScore:58, recommendation:'rejected' }
  ],

  /* ── TRAINING JOBS ────────────────────────────────────────── */
  trainingJobs: [
    { id:'train_xtts_hi_001', datasetId:'ds_hi_001', baseModel:'XTTS-v2', langCode:'hi', type:'fine_tune',      gpu:'H100', gpuCount:1, batchSize:16, lr:0.00001, epochs:50, status:'completed', currentEpoch:50, trainLoss:0.42, valLoss:0.58, startedAt:'2026-04-20', completedAt:'2026-04-22' },
    { id:'train_xtts_en_001', datasetId:'ds_en_001', baseModel:'XTTS-v2', langCode:'en', type:'fine_tune',      gpu:'H100', gpuCount:2, batchSize:32, lr:0.00001, epochs:50, status:'completed', currentEpoch:50, trainLoss:0.38, valLoss:0.51, startedAt:'2026-04-18', completedAt:'2026-04-21' },
    { id:'train_xtts_ta_001', datasetId:'ds_ta_001', baseModel:'XTTS-v2', langCode:'ta', type:'fine_tune',      gpu:'A100', gpuCount:1, batchSize:16, lr:0.00001, epochs:50, status:'running',   currentEpoch:32, trainLoss:0.68, valLoss:0.82, startedAt:'2026-04-27', completedAt:null },
    { id:'train_xtts_hi_002', datasetId:'ds_hi_002', baseModel:'XTTS-v2', langCode:'hi', type:'speaker_adapt',  gpu:'H100', gpuCount:1, batchSize:8,  lr:0.000005,epochs:30, status:'running',   currentEpoch:18, trainLoss:0.92, valLoss:1.04, startedAt:'2026-04-28', completedAt:null },
    { id:'train_xtts_bn_001', datasetId:'ds_bn_001', baseModel:'XTTS-v2', langCode:'bn', type:'language_adapt', gpu:'B200', gpuCount:1, batchSize:16, lr:0.00001, epochs:40, status:'queued',    currentEpoch:0,  trainLoss:null, valLoss:null, startedAt:null,          completedAt:null },
    { id:'train_xtts_mr_001', datasetId:'ds_mr_001', baseModel:'XTTS-v2', langCode:'mr', type:'fine_tune',      gpu:'A100', gpuCount:1, batchSize:16, lr:0.00001, epochs:50, status:'failed',    currentEpoch:12, trainLoss:1.84, valLoss:2.21, startedAt:'2026-04-26', completedAt:null }
  ],

  /* ── LOSS HISTORY (for loss curve chart) ─────────────────── */
  lossHistory: {
    epochs:    [1,5,10,15,20,25,30,35,40,45,50],
    trainLoss: [2.42,1.88,1.42,1.12,0.92,0.78,0.66,0.56,0.49,0.45,0.42],
    valLoss:   [2.61,2.04,1.58,1.24,1.04,0.89,0.76,0.67,0.62,0.59,0.58]
  },

  /* ── EVALUATIONS ──────────────────────────────────────────── */
  evaluations: [
    { id:'eval_xtts_hi_001', jobId:'train_xtts_hi_001', modelVersion:'xtts_hi_v001', langCode:'hi', mos:4.18, wer:0.064, cer:0.035, speakerSimilarity:0.86, latency:310, firstAudioLatency:190, clippingRatio:0.004, pronunciation:88, naturalness:84, emotion:78, grade:'A', status:'approved' },
    { id:'eval_xtts_en_001', jobId:'train_xtts_en_001', modelVersion:'xtts_en_v001', langCode:'en', mos:4.32, wer:0.038, cer:0.022, speakerSimilarity:0.91, latency:280, firstAudioLatency:165, clippingRatio:0.002, pronunciation:93, naturalness:90, emotion:85, grade:'A', status:'approved' },
    { id:'eval_xtts_ta_001', jobId:'train_xtts_ta_001', modelVersion:'xtts_ta_v001', langCode:'ta', mos:4.05, wer:0.052, cer:0.028, speakerSimilarity:0.83, latency:330, firstAudioLatency:205, clippingRatio:0.005, pronunciation:86, naturalness:82, emotion:74, grade:'B', status:'approved' },
    { id:'eval_xtts_bn_001', jobId:'train_xtts_bn_001', modelVersion:'xtts_bn_v001', langCode:'bn', mos:3.88, wer:0.092, cer:0.051, speakerSimilarity:0.78, latency:380, firstAudioLatency:240, clippingRatio:0.007, pronunciation:80, naturalness:76, emotion:68, grade:'C', status:'needs_retraining' },
    { id:'eval_xtts_mr_001', jobId:'train_xtts_mr_001', modelVersion:'xtts_mr_v001', langCode:'mr', mos:3.72, wer:0.118, cer:0.068, speakerSimilarity:0.74, latency:420, firstAudioLatency:270, clippingRatio:0.009, pronunciation:75, naturalness:70, emotion:62, grade:'C', status:'needs_retraining' },
    { id:'eval_xtts_kn_001', jobId:'train_xtts_kn_001', modelVersion:'xtts_kn_v001', langCode:'kn', mos:4.08, wer:0.058, cer:0.031, speakerSimilarity:0.84, latency:320, firstAudioLatency:198, clippingRatio:0.004, pronunciation:87, naturalness:83, emotion:76, grade:'B', status:'approved' }
  ],

  /* ── MOS VERSION HISTORY (for line chart) ────────────────── */
  mosHistory: {
    versions: ['v001','v002','v003','v004','v005','v006'],
    hindi:    [3.62, 3.78, 3.91, 4.02, 4.12, 4.18],
    english:  [3.80, 3.94, 4.08, 4.18, 4.26, 4.32],
    tamil:    [3.51, 3.68, 3.80, 3.91, 3.98, 4.05]
  },

  /* ── VOICES ───────────────────────────────────────────────── */
  voices: [
    { id:'voice_hi_f_support_001', name:'Hindi Female Support 01',  modelVersion:'xtts_hi_v001', speakerId:'spk_hi_f_001', language:'Hindi',   accent:'North Indian', gender:'female',  useCase:'support',     tone:'polite',    mos:4.18, similarity:0.86, latency:300, status:'production', customer:'all' },
    { id:'voice_en_n_support_001', name:'English Neutral Support 01',modelVersion:'xtts_en_v001', speakerId:'spk_en_m_001', language:'English', accent:'Neutral',      gender:'neutral', useCase:'support',     tone:'formal',    mos:4.32, similarity:0.91, latency:275, status:'production', customer:'all' },
    { id:'voice_en_f_sales_001',   name:'English Female Sales 01',   modelVersion:'xtts_en_v001', speakerId:'spk_en_f_001', language:'English', accent:'Neutral',      gender:'female',  useCase:'sales',       tone:'assertive', mos:4.28, similarity:0.89, latency:282, status:'production', customer:'cust_bank_001' },
    { id:'voice_hi_m_coll_001',    name:'Hindi Male Collections 01', modelVersion:'xtts_hi_v001', speakerId:'spk_hi_m_001', language:'Hindi',   accent:'Delhi',        gender:'male',    useCase:'collections', tone:'assertive', mos:4.10, similarity:0.84, latency:315, status:'production', customer:'all' },
    { id:'voice_ta_m_sales_001',   name:'Tamil Male Sales 01',       modelVersion:'xtts_ta_v001', speakerId:'spk_ta_m_001', language:'Tamil',   accent:'Chennai',      gender:'male',    useCase:'sales',       tone:'polite',    mos:4.05, similarity:0.83, latency:335, status:'staging',    customer:'cust_fin_002' },
    { id:'voice_kn_m_support_001', name:'Kannada Male Support 01',   modelVersion:'xtts_kn_v001', speakerId:'spk_kn_m_001', language:'Kannada', accent:'Bangalore',    gender:'male',    useCase:'support',     tone:'formal',    mos:4.08, similarity:0.84, latency:322, status:'staging',    customer:'all' },
    { id:'voice_hi_f_support_002', name:'Hindi Female Support 02',   modelVersion:'xtts_hi_v001', speakerId:'spk_hi_f_002', language:'Hindi',   accent:'North Indian', gender:'female',  useCase:'support',     tone:'polite',    mos:3.98, similarity:0.81, latency:308, status:'draft',      customer:'all' },
    { id:'voice_en_m_coll_001',    name:'English Male Collections 01',modelVersion:'xtts_en_v001',speakerId:'spk_en_m_002', language:'English', accent:'Neutral',      gender:'male',    useCase:'collections', tone:'assertive', mos:4.22, similarity:0.88, latency:290, status:'production', customer:'cust_bank_001' }
  ],

  /* ── TTS REQUESTS — hourly (24h) ─────────────────────────── */
  ttsRequests: [
    { hour:'00:00', requests:1820, success:1784, failed:36,  avgLatency:328 },
    { hour:'01:00', requests:1240, success:1218, failed:22,  avgLatency:315 },
    { hour:'02:00', requests:980,  success:962,  failed:18,  avgLatency:310 },
    { hour:'03:00', requests:820,  success:805,  failed:15,  avgLatency:308 },
    { hour:'04:00', requests:760,  success:748,  failed:12,  avgLatency:305 },
    { hour:'05:00', requests:910,  success:894,  failed:16,  avgLatency:312 },
    { hour:'06:00', requests:1480, success:1450, failed:30,  avgLatency:322 },
    { hour:'07:00', requests:2840, success:2782, failed:58,  avgLatency:338 },
    { hour:'08:00', requests:4200, success:4108, failed:92,  avgLatency:352 },
    { hour:'09:00', requests:5100, success:4988, failed:112, avgLatency:368 },
    { hour:'10:00', requests:5480, success:5362, failed:118, avgLatency:374 },
    { hour:'11:00', requests:5620, success:5498, failed:122, avgLatency:380 },
    { hour:'12:00', requests:4980, success:4878, failed:102, avgLatency:362 },
    { hour:'13:00', requests:4820, success:4720, failed:100, avgLatency:358 },
    { hour:'14:00', requests:5240, success:5128, failed:112, avgLatency:371 },
    { hour:'15:00', requests:5380, success:5264, failed:116, avgLatency:376 },
    { hour:'16:00', requests:5120, success:5012, failed:108, avgLatency:366 },
    { hour:'17:00', requests:4680, success:4584, failed:96,  avgLatency:354 },
    { hour:'18:00', requests:3840, success:3762, failed:78,  avgLatency:342 },
    { hour:'19:00', requests:3200, success:3136, failed:64,  avgLatency:335 },
    { hour:'20:00', requests:2880, success:2824, failed:56,  avgLatency:330 },
    { hour:'21:00', requests:2420, success:2374, failed:46,  avgLatency:326 },
    { hour:'22:00', requests:2080, success:2040, failed:40,  avgLatency:322 },
    { hour:'23:00', requests:1830, success:1795, failed:35,  avgLatency:319 }
  ]

};