/* ═══════════════════════════════════════════════════════════════
   seed.js — Global SEED data object
   Injected before all dashboard JS files via JSP layout.
   Covers: speakers, datasets, audioClips, datasetScores,
           trainingJobs, evaluations, deployments, lossHistory
════════════════════════════════════════════════════════════════ */

const SEED = (function () {

  /* ── SPEAKERS ────────────────────────────────────────────────── */
  const speakers = [
    { id:'spk_001', name:'Aanya Sharma',    langCode:'hi', gender:'F', age:28, accent:'Delhi',      nativeLang:'Hindi',      recordingEnv:'studio', totalClips:4820, totalHours:9.4,  status:'active'   },
    { id:'spk_002', name:'Rahul Verma',     langCode:'hi', gender:'M', age:34, accent:'Mumbai',     nativeLang:'Hindi',      recordingEnv:'studio', totalClips:5140, totalHours:10.2, status:'active'   },
    { id:'spk_003', name:'Priya Nair',      langCode:'ml', gender:'F', age:31, accent:'Kochi',      nativeLang:'Malayalam',  recordingEnv:'studio', totalClips:3960, totalHours:7.8,  status:'active'   },
    { id:'spk_004', name:'Karthik Raj',     langCode:'ta', gender:'M', age:27, accent:'Chennai',    nativeLang:'Tamil',      recordingEnv:'booth',  totalClips:4410, totalHours:8.6,  status:'active'   },
    { id:'spk_005', name:'Sneha Kulkarni',  langCode:'mr', gender:'F', age:30, accent:'Pune',       nativeLang:'Marathi',    recordingEnv:'studio', totalClips:3720, totalHours:7.3,  status:'active'   },
    { id:'spk_006', name:'Arjun Das',       langCode:'bn', gender:'M', age:36, accent:'Kolkata',    nativeLang:'Bengali',    recordingEnv:'booth',  totalClips:4100, totalHours:8.0,  status:'active'   },
    { id:'spk_007', name:'Meera Iyer',      langCode:'kn', gender:'F', age:29, accent:'Bengaluru',  nativeLang:'Kannada',    recordingEnv:'studio', totalClips:3580, totalHours:7.0,  status:'active'   },
    { id:'spk_008', name:'Vikram Reddy',    langCode:'te', gender:'M', age:33, accent:'Hyderabad',  nativeLang:'Telugu',     recordingEnv:'studio', totalClips:4230, totalHours:8.3,  status:'active'   },
    { id:'spk_009', name:'Isha Patel',      langCode:'gu', gender:'F', age:25, accent:'Ahmedabad',  nativeLang:'Gujarati',   recordingEnv:'booth',  totalClips:3340, totalHours:6.5,  status:'active'   },
    { id:'spk_010', name:'Manish Singh',    langCode:'hi', gender:'M', age:40, accent:'Lucknow',    nativeLang:'Hindi',      recordingEnv:'remote', totalClips:2800, totalHours:5.5,  status:'inactive' },
    { id:'spk_011', name:'Divya Menon',     langCode:'ml', gender:'F', age:26, accent:'Trivandrum', nativeLang:'Malayalam',  recordingEnv:'studio', totalClips:3100, totalHours:6.1,  status:'active'   },
    { id:'spk_012', name:'Suresh Kumar',    langCode:'ta', gender:'M', age:45, accent:'Madurai',    nativeLang:'Tamil',      recordingEnv:'studio', totalClips:4600, totalHours:9.0,  status:'active'   }
  ];

  /* ── DATASETS ────────────────────────────────────────────────── */
  const datasets = [
    { id:'ds_hi_001', name:'Hindi Studio v2',     langCode:'hi', category:'studio',    totalClips:28400, totalHours:55.6, speakers:3, status:'approved',    createdBy:'admin',     createdAt:'2025-01-10' },
    { id:'ds_hi_002', name:'Hindi Conversational', langCode:'hi', category:'field',     totalClips:14200, totalHours:27.8, speakers:2, status:'in_review',   createdBy:'annotator', createdAt:'2025-03-02' },
    { id:'ds_ml_001', name:'Malayalam Studio v1',  langCode:'ml', category:'studio',    totalClips:18600, totalHours:36.4, speakers:2, status:'approved',    createdBy:'admin',     createdAt:'2025-01-22' },
    { id:'ds_ta_001', name:'Tamil Studio v1',      langCode:'ta', category:'studio',    totalClips:22100, totalHours:43.2, speakers:2, status:'approved',    createdBy:'admin',     createdAt:'2025-02-05' },
    { id:'ds_mr_001', name:'Marathi Studio v1',    langCode:'mr', category:'studio',    totalClips:17200, totalHours:33.6, speakers:1, status:'in_review',   createdBy:'annotator', createdAt:'2025-03-15' },
    { id:'ds_bn_001', name:'Bengali Studio v1',    langCode:'bn', category:'studio',    totalClips:19800, totalHours:38.7, speakers:1, status:'approved',    createdBy:'admin',     createdAt:'2025-02-18' },
    { id:'ds_kn_001', name:'Kannada Studio v1',    langCode:'kn', category:'studio',    totalClips:16400, totalHours:32.0, speakers:1, status:'draft',       createdBy:'annotator', createdAt:'2025-04-01' },
    { id:'ds_te_001', name:'Telugu Studio v1',     langCode:'te', category:'studio',    totalClips:20600, totalHours:40.2, speakers:1, status:'approved',    createdBy:'admin',     createdAt:'2025-02-28' },
    { id:'ds_gu_001', name:'Gujarati Studio v1',   langCode:'gu', category:'studio',    totalClips:15300, totalHours:29.9, speakers:1, status:'in_review',   createdBy:'annotator', createdAt:'2025-04-10' },
    { id:'ds_hi_003', name:'Hindi Audiobook',      langCode:'hi', category:'audiobook', totalClips:9800,  totalHours:19.2, speakers:1, status:'approved',    createdBy:'admin',     createdAt:'2025-03-20' }
  ];

  /* ── AUDIO CLIPS (sample — 20 representative rows) ──────────── */
  const audioClips = [
    { id:'clip_0001', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_001', duration:4.2, noiseScore:0.041, silenceRatio:0.08, wer:0.042, qualityScore:92, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0002', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_001', duration:3.8, noiseScore:0.038, silenceRatio:0.07, wer:0.031, qualityScore:94, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0003', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_002', duration:5.1, noiseScore:0.210, silenceRatio:0.12, wer:0.098, qualityScore:54, status:'fail',   rejectionReason:'high noise',        reviewedBy:'qc_bot'    },
    { id:'clip_0004', datasetId:'ds_hi_001', langCode:'hi', speakerId:'spk_002', duration:4.6, noiseScore:0.055, silenceRatio:0.32, wer:0.061, qualityScore:67, status:'fail',   rejectionReason:'high silence',      reviewedBy:'qc_bot'    },
    { id:'clip_0005', datasetId:'ds_ml_001', langCode:'ml', speakerId:'spk_003', duration:3.9, noiseScore:0.036, silenceRatio:0.06, wer:0.028, qualityScore:95, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0006', datasetId:'ds_ml_001', langCode:'ml', speakerId:'spk_003', duration:4.3, noiseScore:0.190, silenceRatio:0.09, wer:0.112, qualityScore:49, status:'fail',   rejectionReason:'transcript mismatch',reviewedBy:'qc_bot'   },
    { id:'clip_0007', datasetId:'ds_ta_001', langCode:'ta', speakerId:'spk_004', duration:4.7, noiseScore:0.044, silenceRatio:0.08, wer:0.039, qualityScore:91, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0008', datasetId:'ds_ta_001', langCode:'ta', speakerId:'spk_004', duration:3.5, noiseScore:0.052, silenceRatio:0.10, wer:0.045, qualityScore:88, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0009', datasetId:'ds_mr_001', langCode:'mr', speakerId:'spk_005', duration:4.1, noiseScore:0.078, silenceRatio:0.14, wer:0.071, qualityScore:72, status:'review', rejectionReason:null,                reviewedBy:'annotator' },
    { id:'clip_0010', datasetId:'ds_mr_001', langCode:'mr', speakerId:'spk_005', duration:4.8, noiseScore:0.230, silenceRatio:0.11, wer:0.130, qualityScore:41, status:'fail',   rejectionReason:'clipping',          reviewedBy:'qc_bot'    },
    { id:'clip_0011', datasetId:'ds_bn_001', langCode:'bn', speakerId:'spk_006', duration:5.2, noiseScore:0.033, silenceRatio:0.07, wer:0.033, qualityScore:93, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0012', datasetId:'ds_bn_001', langCode:'bn', speakerId:'spk_006', duration:4.0, noiseScore:0.047, silenceRatio:0.09, wer:0.038, qualityScore:90, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0013', datasetId:'ds_kn_001', langCode:'kn', speakerId:'spk_007', duration:3.7, noiseScore:0.062, silenceRatio:0.13, wer:0.058, qualityScore:78, status:'review', rejectionReason:null,                reviewedBy:'annotator' },
    { id:'clip_0014', datasetId:'ds_kn_001', langCode:'kn', speakerId:'spk_007', duration:4.4, noiseScore:0.175, silenceRatio:0.16, wer:0.095, qualityScore:53, status:'fail',   rejectionReason:'low quality score', reviewedBy:'qc_bot'    },
    { id:'clip_0015', datasetId:'ds_te_001', langCode:'te', speakerId:'spk_008', duration:4.9, noiseScore:0.039, silenceRatio:0.07, wer:0.034, qualityScore:93, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0016', datasetId:'ds_te_001', langCode:'te', speakerId:'spk_008', duration:3.6, noiseScore:0.043, silenceRatio:0.08, wer:0.040, qualityScore:91, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0017', datasetId:'ds_gu_001', langCode:'gu', speakerId:'spk_009', duration:4.2, noiseScore:0.071, silenceRatio:0.12, wer:0.064, qualityScore:75, status:'review', rejectionReason:null,                reviewedBy:'annotator' },
    { id:'clip_0018', datasetId:'ds_gu_001', langCode:'gu', speakerId:'spk_009', duration:5.0, noiseScore:0.055, silenceRatio:0.10, wer:0.049, qualityScore:84, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    },
    { id:'clip_0019', datasetId:'ds_hi_003', langCode:'hi', speakerId:'spk_010', duration:6.1, noiseScore:0.082, silenceRatio:0.15, wer:0.076, qualityScore:70, status:'review', rejectionReason:null,                reviewedBy:'annotator' },
    { id:'clip_0020', datasetId:'ds_hi_003', langCode:'hi', speakerId:'spk_012', duration:5.8, noiseScore:0.035, silenceRatio:0.06, wer:0.030, qualityScore:95, status:'pass',   rejectionReason:null,                reviewedBy:'qc_bot'    }
  ];

  /* ── DATASET SCORES ─────────────────────────────────────────── */
  const datasetScores = [
    { id:'score_001', datasetId:'ds_hi_001', audioClarity:91, transcriptAccuracy:89, speakerConsistency:93, accentPurity:88, languagePurity:95, coverage:90, recommendation:'approved_for_training' },
    { id:'score_002', datasetId:'ds_hi_002', audioClarity:74, transcriptAccuracy:71, speakerConsistency:76, accentPurity:72, languagePurity:80, coverage:68, recommendation:'rework'                },
    { id:'score_003', datasetId:'ds_ml_001', audioClarity:88, transcriptAccuracy:85, speakerConsistency:90, accentPurity:86, languagePurity:93, coverage:84, recommendation:'approved_for_training' },
    { id:'score_004', datasetId:'ds_ta_001', audioClarity:90, transcriptAccuracy:88, speakerConsistency:91, accentPurity:87, languagePurity:94, coverage:88, recommendation:'approved_for_training' },
    { id:'score_005', datasetId:'ds_mr_001', audioClarity:77, transcriptAccuracy:74, speakerConsistency:78, accentPurity:73, languagePurity:82, coverage:70, recommendation:'rework'                },
    { id:'score_006', datasetId:'ds_bn_001', audioClarity:86, transcriptAccuracy:83, speakerConsistency:87, accentPurity:84, languagePurity:91, coverage:82, recommendation:'approved_for_training' },
    { id:'score_007', datasetId:'ds_kn_001', audioClarity:62, transcriptAccuracy:59, speakerConsistency:64, accentPurity:60, languagePurity:68, coverage:55, recommendation:'rejected'              },
    { id:'score_008', datasetId:'ds_te_001', audioClarity:89, transcriptAccuracy:86, speakerConsistency:90, accentPurity:85, languagePurity:92, coverage:86, recommendation:'approved_for_training' },
    { id:'score_009', datasetId:'ds_gu_001', audioClarity:75, transcriptAccuracy:72, speakerConsistency:77, accentPurity:71, languagePurity:79, coverage:67, recommendation:'rework'                },
    { id:'score_010', datasetId:'ds_hi_003', audioClarity:83, transcriptAccuracy:80, speakerConsistency:84, accentPurity:81, languagePurity:88, coverage:78, recommendation:'approved_for_training' }
  ];

  /* ── TRAINING JOBS ──────────────────────────────────────────── */
  const trainingJobs = [
    { id:'job_001', datasetId:'ds_hi_001', baseModel:'FastSpeech2', langCode:'hi', type:'full_train',   gpu:'A100', epochs:50, currentEpoch:50, trainLoss:0.412, valLoss:0.438, status:'completed', startedAt:'2025-03-01' },
    { id:'job_002', datasetId:'ds_ml_001', baseModel:'FastSpeech2', langCode:'ml', type:'full_train',   gpu:'A100', epochs:50, currentEpoch:50, trainLoss:0.438, valLoss:0.461, status:'completed', startedAt:'2025-03-10' },
    { id:'job_003', datasetId:'ds_ta_001', baseModel:'VITS',        langCode:'ta', type:'full_train',   gpu:'V100', epochs:60, currentEpoch:60, trainLoss:0.396, valLoss:0.421, status:'completed', startedAt:'2025-03-18' },
    { id:'job_004', datasetId:'ds_bn_001', baseModel:'VITS',        langCode:'bn', type:'full_train',   gpu:'V100', epochs:60, currentEpoch:60, trainLoss:0.421, valLoss:0.448, status:'completed', startedAt:'2025-03-25' },
    { id:'job_005', datasetId:'ds_te_001', baseModel:'YourTTS',     langCode:'te', type:'full_train',   gpu:'A100', epochs:55, currentEpoch:55, trainLoss:0.404, valLoss:0.430, status:'completed', startedAt:'2025-04-02' },
    { id:'job_006', datasetId:'ds_hi_003', baseModel:'FastSpeech2', langCode:'hi', type:'fine_tune',    gpu:'T4',   epochs:20, currentEpoch:20, trainLoss:0.381, valLoss:0.402, status:'completed', startedAt:'2025-04-10' },
    { id:'job_007', datasetId:'ds_hi_002', baseModel:'FastSpeech2', langCode:'hi', type:'fine_tune',    gpu:'T4',   epochs:20, currentEpoch:14, trainLoss:0.510, valLoss:0.534, status:'running',   startedAt:'2025-05-01' },
    { id:'job_008', datasetId:'ds_mr_001', baseModel:'VITS',        langCode:'mr', type:'full_train',   gpu:'V100', epochs:60, currentEpoch:0,  trainLoss:null,  valLoss:null,  status:'queued',    startedAt:null         },
    { id:'job_009', datasetId:'ds_gu_001', baseModel:'YourTTS',     langCode:'gu', type:'full_train',   gpu:'A100', epochs:55, currentEpoch:0,  trainLoss:null,  valLoss:null,  status:'queued',    startedAt:null         },
    { id:'job_010', datasetId:'ds_kn_001', baseModel:'FastSpeech2', langCode:'kn', type:'full_train',   gpu:'T4',   epochs:50, currentEpoch:22, trainLoss:0.721, valLoss:0.810, status:'failed',    startedAt:'2025-04-28' }
  ];

  /* ── LOSS HISTORY (epoch 1–20 of job_001) ───────────────────── */
  const lossHistory = {
    epochs   : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
    trainLoss: [2.61,2.18,1.84,1.55,1.31,1.12,0.96,0.83,0.73,0.64,0.57,0.52,0.48,0.45,0.43,0.42,0.418,0.414,0.413,0.412],
    valLoss  : [2.74,2.31,1.97,1.67,1.43,1.24,1.08,0.95,0.84,0.75,0.68,0.62,0.57,0.54,0.51,0.49,0.47,0.456,0.445,0.438]
  };

  /* ── EVALUATIONS ────────────────────────────────────────────── */
  const evaluations = [
    { id:'eval_001', modelVersion:'hi_fs2_v1.0', langCode:'hi', mos:3.82, wer:0.072, cer:0.034, rtf:0.48, ttfbMs:210, evaluatedBy:'eval_team', evaluatedAt:'2025-04-05' },
    { id:'eval_002', modelVersion:'hi_fs2_v1.1', langCode:'hi', mos:4.01, wer:0.058, cer:0.026, rtf:0.44, ttfbMs:195, evaluatedBy:'eval_team', evaluatedAt:'2025-04-20' },
    { id:'eval_003', modelVersion:'hi_fs2_v1.2', langCode:'hi', mos:4.18, wer:0.049, cer:0.021, rtf:0.41, ttfbMs:180, evaluatedBy:'eval_team', evaluatedAt:'2025-05-05' },
    { id:'eval_004', modelVersion:'ml_fs2_v1.0', langCode:'ml', mos:3.91, wer:0.068, cer:0.031, rtf:0.46, ttfbMs:200, evaluatedBy:'eval_team', evaluatedAt:'2025-04-12' },
    { id:'eval_005', modelVersion:'ml_fs2_v1.1', langCode:'ml', mos:4.08, wer:0.055, cer:0.024, rtf:0.43, ttfbMs:188, evaluatedBy:'eval_team', evaluatedAt:'2025-04-28' },
    { id:'eval_006', modelVersion:'ta_vits_v1.0', langCode:'ta', mos:4.22, wer:0.044, cer:0.019, rtf:0.39, ttfbMs:172, evaluatedBy:'eval_team', evaluatedAt:'2025-05-02' },
    { id:'eval_007', modelVersion:'bn_vits_v1.0', langCode:'bn', mos:4.10, wer:0.051, cer:0.022, rtf:0.42, ttfbMs:185, evaluatedBy:'eval_team', evaluatedAt:'2025-05-08' },
    { id:'eval_008', modelVersion:'te_ytts_v1.0', langCode:'te', mos:4.15, wer:0.047, cer:0.020, rtf:0.40, ttfbMs:178, evaluatedBy:'eval_team', evaluatedAt:'2025-05-14' }
  ];

  /* ── DEPLOYMENTS ────────────────────────────────────────────── */
  const deployments = [
    {
      id:'dep_001', modelVersion:'hi_fs2_v1.2', langCode:'hi', region:'ap-south-1',
      status:'live', uptimePct:99.92, latencyP50:142, latencyP95:268, latencyP99:410,
      requestsToday:48200,
      dailyRequests:[38400,40100,42300,44800,45900,47200,48200,46800,47600,49100,48500,47900,48200],
      deployedAt:'2025-05-10', deployedBy:'devops'
    },
    {
      id:'dep_002', modelVersion:'ml_fs2_v1.1', langCode:'ml', region:'ap-south-1',
      status:'live', uptimePct:99.88, latencyP50:148, latencyP95:275, latencyP99:422,
      requestsToday:22400,
      dailyRequests:[18200,19600,20800,21400,22000,22400,21900,22100,22800,22300,22600,22400,22400],
      deployedAt:'2025-05-01', deployedBy:'devops'
    },
    {
      id:'dep_003', modelVersion:'ta_vits_v1.0', langCode:'ta', region:'ap-south-2',
      status:'live', uptimePct:99.81, latencyP50:155, latencyP95:290, latencyP99:435,
      requestsToday:31600,
      dailyRequests:[26800,28100,29400,30200,30800,31200,31600,30900,31400,32100,31800,31600,31600],
      deployedAt:'2025-05-05', deployedBy:'devops'
    },
    {
      id:'dep_004', modelVersion:'bn_vits_v1.0', langCode:'bn', region:'ap-south-1',
      status:'live', uptimePct:99.74, latencyP50:158, latencyP95:295, latencyP99:440,
      requestsToday:19800, dailyRequests:null,
      deployedAt:'2025-05-12', deployedBy:'devops'
    },
    {
      id:'dep_005', modelVersion:'te_ytts_v1.0', langCode:'te', region:'ap-south-2',
      status:'live', uptimePct:99.68, latencyP50:161, latencyP95:300, latencyP99:448,
      requestsToday:24100, dailyRequests:null,
      deployedAt:'2025-05-15', deployedBy:'devops'
    },
    {
      id:'dep_006', modelVersion:'hi_fs2_v1.1', langCode:'hi', region:'ap-south-1',
      status:'deprecated', uptimePct:99.60, latencyP50:168, latencyP95:314, latencyP99:462,
      requestsToday:0, dailyRequests:null,
      deployedAt:'2025-04-22', deployedBy:'devops'
    },
    {
      id:'dep_007', modelVersion:'mr_vits_v0.9', langCode:'mr', region:'ap-south-1',
      status:'staging', uptimePct:98.40, latencyP50:181, latencyP95:340, latencyP99:492,
      requestsToday:0, dailyRequests:null,
      deployedAt:'2025-05-18', deployedBy:'mlops'
    },
    {
      id:'dep_008', modelVersion:'gu_ytts_v0.8', langCode:'gu', region:'ap-south-2',
      status:'staging', uptimePct:97.80, latencyP50:195, latencyP95:362, latencyP99:518,
      requestsToday:0, dailyRequests:null,
      deployedAt:'2025-05-20', deployedBy:'mlops'
    }
  ];

  return { speakers, datasets, audioClips, datasetScores, trainingJobs, lossHistory, evaluations, deployments };

})();