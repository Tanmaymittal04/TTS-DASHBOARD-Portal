/* ═══════════════════════════════════════════════════════════════
   scoring.js — Dataset Scoring / Readiness Dashboard
   Charts + DataTable for dataset_scores
════════════════════════════════════════════════════════════════ */

(function () {
  'use strict';

  const MUTED  = '#8888aa';
  const BORDER = 'rgba(255,255,255,0.07)';

  const P = {
    primary : '#6366f1',
    success : '#22c55e',
    warning : '#f59e0b',
    danger  : '#ef4444',
    info    : '#06b6d4',
    purple  : '#a855f7',
    pink    : '#ec4899',
    alpha   : (hex, a) => hex + Math.round(a * 255).toString(16).padStart(2, '0')
  };

  function gridOpts() { return { color: BORDER, drawBorder: false }; }
  function tickOpts() { return { color: MUTED, maxRotation: 0 }; }

  /* ── SCORING WEIGHTS ────────────────────────────────────────── */
  const WEIGHTS = {
    audioClarity       : 0.25,
    transcriptAccuracy : 0.20,
    speakerConsistency : 0.25,
    accentPurity       : 0.10,
    languagePurity     : 0.10,
    coverage           : 0.10
  };

  /* Verify / recompute final scores from components */
  function computeFinal(s) {
    return Math.round(
      s.audioClarity       * WEIGHTS.audioClarity       +
      s.transcriptAccuracy * WEIGHTS.transcriptAccuracy +
      s.speakerConsistency * WEIGHTS.speakerConsistency +
      s.accentPurity       * WEIGHTS.accentPurity       +
      s.languagePurity     * WEIGHTS.languagePurity     +
      s.coverage           * WEIGHTS.coverage
    );
  }

  function recColor(r) {
    if (r === 'approved_for_training') return P.success;
    if (r === 'rework')                return P.warning;
    return P.danger;
  }

  function recLabel(r) {
    if (r === 'approved_for_training') return 'Approved';
    if (r === 'rework')                return 'Rework';
    return 'Rejected';
  }

  /* ── 1. RADAR — HINDI DATASET (ds_hi_001) ───────────────────── */
  const hindiScore = SEED.datasetScores.find(s => s.datasetId === 'ds_hi_001');
  if (hindiScore) {
    new Chart(document.getElementById('chartRadarHindi'), {
      type: 'radar',
      data: {
        labels: [
          'Audio Clarity',
          'Transcript Acc.',
          'Speaker Consistency',
          'Accent Purity',
          'Language Purity',
          'Coverage'
        ],
        datasets: [{
          label          : 'ds_hi_001',
          data           : [
            hindiScore.audioClarity,
            hindiScore.transcriptAccuracy,
            hindiScore.speakerConsistency,
            hindiScore.accentPurity,
            hindiScore.languagePurity,
            hindiScore.coverage
          ],
          borderColor    : P.primary,
          backgroundColor: P.alpha(P.primary, 0.18),
          borderWidth    : 2,
          pointBackgroundColor: P.primary,
          pointRadius    : 4
        }]
      },
      options: {
        responsive         : true,
        maintainAspectRatio: false,
        plugins            : { legend: { display: false } },
        scales             : {
          r: {
            min        : 50,
            max        : 100,
            ticks      : { stepSize: 10, color: MUTED, backdropColor: 'transparent', font: { size: 10 } },
            grid       : { color: BORDER },
            pointLabels: { color: MUTED, font: { size: 11 } },
            angleLines : { color: BORDER }
          }
        }
      }
    });
  }

  /* ── 2. FINAL SCORES BAR ────────────────────────────────────── */
  const scoreLabels = SEED.datasetScores.map(s => s.datasetId);
  const scoreValues = SEED.datasetScores.map(s => computeFinal(s));
  const scoreColors = SEED.datasetScores.map(s => recColor(s.recommendation));

  new Chart(document.getElementById('chartFinalScores'), {
    type: 'bar',
    data: {
      labels: scoreLabels,
      datasets: [{
        label          : 'Final Score',
        data           : scoreValues,
        backgroundColor: scoreColors.map(c => P.alpha(c, 0.72)),
        borderColor    : scoreColors,
        borderWidth    : 1,
        borderRadius   : 4
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      plugins            : {
        legend: { display: false },
        annotation: {
          annotations: {
            approvalLine: {
              type     : 'line',
              yMin     : 80,
              yMax     : 80,
              borderColor: P.success,
              borderWidth: 1,
              borderDash : [4, 4]
            },
            reworkLine: {
              type     : 'line',
              yMin     : 65,
              yMax     : 65,
              borderColor: P.warning,
              borderWidth: 1,
              borderDash : [4, 4]
            }
          }
        }
      },
      scales: {
        x: { grid: gridOpts(), ticks: { ...tickOpts(), font: { size: 10 } } },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          min  : 50, max: 100,
          title: { display: true, text: 'Score', color: MUTED, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 3. RECOMMENDATION DOUGHNUT ─────────────────────────────── */
  const recCounts = SEED.datasetScores.reduce((acc, s) => {
    const label = recLabel(s.recommendation);
    acc[label] = (acc[label] || 0) + 1;
    return acc;
  }, {});

  new Chart(document.getElementById('chartRecommendation'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(recCounts),
      datasets: [{
        data           : Object.values(recCounts),
        backgroundColor: [P.success, P.warning, P.danger],
        borderWidth    : 2,
        borderColor    : '#16161d',
        hoverOffset    : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      cutout             : '68%',
      plugins            : { legend: { position: 'right' } }
    }
  });

  /* ── 4. SCORE COMPONENTS GROUPED BAR ────────────────────────── */
  /* Show top 5 datasets for readability */
  const top5 = SEED.datasetScores.slice(0, 5);

  new Chart(document.getElementById('chartScoreHeatmap'), {
    type: 'bar',
    data: {
      labels: top5.map(s => s.datasetId),
      datasets: [
        {
          label          : 'Audio Clarity',
          data           : top5.map(s => s.audioClarity),
          backgroundColor: P.alpha(P.primary, 0.75),
          borderRadius   : 2
        },
        {
          label          : 'Transcript Acc.',
          data           : top5.map(s => s.transcriptAccuracy),
          backgroundColor: P.alpha(P.success, 0.75),
          borderRadius   : 2
        },
        {
          label          : 'Spk Consistency',
          data           : top5.map(s => s.speakerConsistency),
          backgroundColor: P.alpha(P.purple, 0.75),
          borderRadius   : 2
        },
        {
          label          : 'Accent Purity',
          data           : top5.map(s => s.accentPurity),
          backgroundColor: P.alpha(P.warning, 0.75),
          borderRadius   : 2
        },
        {
          label          : 'Coverage',
          data           : top5.map(s => s.coverage),
          backgroundColor: P.alpha(P.pink, 0.75),
          borderRadius   : 2
        }
      ]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      interaction        : { mode: 'index', intersect: false },
      plugins: {
        legend: {
          position: 'top',
          align   : 'end',
          labels  : { boxWidth: 10, padding: 10, font: { size: 11 } }
        }
      },
      scales: {
        x: { grid: gridOpts(), ticks: { ...tickOpts(), font: { size: 10 } } },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          min  : 50, max: 100,
          title: { display: true, text: 'Score', color: MUTED, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 5. DATATABLES — SCORE RECORDS ──────────────────────────── */
  const recBadge = r => {
    const map = {
      'approved_for_training': ['approved', 'Approved'],
      'rework'               : ['pending',  'Rework'],
      'rejected'             : ['rejected', 'Rejected']
    };
    const [cls, label] = map[r] || ['draft', r];
    return `<span class="badge-status badge-${cls}">${label}</span>`;
  };

  const scoreBg = v => {
    if (v >= 85) return 'color:var(--success);font-weight:600';
    if (v >= 70) return 'color:var(--warning);font-weight:600';
    return 'color:var(--danger);font-weight:600';
  };

  const tbody = document.getElementById('scoreTableBody');
  if (tbody) {
    tbody.innerHTML = SEED.datasetScores.map(s => {
      const final = computeFinal(s);
      return `
        <tr>
          <td><code style="font-size:11px;color:var(--primary)">${s.id}</code></td>
          <td style="color:var(--text-muted)">${s.datasetId}</td>
          <td style="text-align:right;${scoreBg(s.audioClarity)}">${s.audioClarity}</td>
          <td style="text-align:right;${scoreBg(s.transcriptAccuracy)}">${s.transcriptAccuracy}</td>
          <td style="text-align:right;${scoreBg(s.speakerConsistency)}">${s.speakerConsistency}</td>
          <td style="text-align:right;${scoreBg(s.accentPurity)}">${s.accentPurity}</td>
          <td style="text-align:right;${scoreBg(s.languagePurity)}">${s.languagePurity}</td>
          <td style="text-align:right;${scoreBg(s.coverage)}">${s.coverage}</td>
          <td style="text-align:right;font-size:15px;${scoreBg(final)}">${final}</td>
          <td>${recBadge(s.recommendation)}</td>
        </tr>
      `;
    }).join('');
  }

  if (typeof $ !== 'undefined' && $.fn.DataTable) {
    $('#tblScores').DataTable({
      pageLength : 7,
      lengthMenu : [7, 10, 25],
      order      : [[8, 'desc']],
      language   : {
        search           : '',
        searchPlaceholder: 'Search scores…',
        lengthMenu       : 'Show _MENU_',
        info             : '_START_–_END_ of _TOTAL_',
        paginate         : { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [2,3,4,5,6,7,8], className: 'dt-right' }
      ]
    });
  }

})();