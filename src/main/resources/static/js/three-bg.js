/* ═══════════════════════════════════════════════════════════════
   three-bg.js — Animated Three.js particle background
   Used only on Executive Overview page
   Lightweight: ~1,200 floating nodes + connection lines
════════════════════════════════════════════════════════════════ */

(function () {
  'use strict';

  const canvas = document.getElementById('three-bg-canvas');
  if (!canvas) return;

  /* ── SCENE SETUP ────────────────────────────────────────────── */
  const renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.setClearColor(0x000000, 0);

  const scene  = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(60, 1, 0.1, 1000);
  camera.position.z = 28;

  /* ── RESIZE HANDLER ─────────────────────────────────────────── */
  function resize() {
    const w = canvas.parentElement.offsetWidth;
    const h = canvas.parentElement.offsetHeight;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }
  resize();
  window.addEventListener('resize', resize);

  /* ── COLOUR HELPERS ─────────────────────────────────────────── */
  function themeColor() {
    const dark = document.documentElement.getAttribute('data-theme') !== 'light';
    return dark
      ? { node: 0x6366f1, line: 0x6366f1, nodeDim: 0x4f51d4 }
      : { node: 0x4f51d4, line: 0x4f51d4, nodeDim: 0x6366f1 };
  }

  /* ── PARTICLES ──────────────────────────────────────────────── */
  const PARTICLE_COUNT = 180;
  const positions  = new Float32Array(PARTICLE_COUNT * 3);
  const velocities = [];

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    const i3 = i * 3;
    positions[i3]     = (Math.random() - 0.5) * 60;
    positions[i3 + 1] = (Math.random() - 0.5) * 36;
    positions[i3 + 2] = (Math.random() - 0.5) * 20;
    velocities.push({
      x: (Math.random() - 0.5) * 0.018,
      y: (Math.random() - 0.5) * 0.012,
      z: (Math.random() - 0.5) * 0.008
    });
  }

  const particleGeo = new THREE.BufferGeometry();
  particleGeo.setAttribute('position', new THREE.BufferAttribute(positions, 3));

  const particleMat = new THREE.PointsMaterial({
    color:       themeColor().node,
    size:        0.28,
    transparent: true,
    opacity:     0.72,
    sizeAttenuation: true
  });

  const particleMesh = new THREE.Points(particleGeo, particleMat);
  scene.add(particleMesh);

  /* ── CONNECTION LINES ───────────────────────────────────────── */
  const LINE_THRESHOLD = 11; // units — closer nodes get a line
  const MAX_LINES      = 260;

  const linePositions = new Float32Array(MAX_LINES * 6);
  const lineGeo       = new THREE.BufferGeometry();
  lineGeo.setAttribute('position', new THREE.BufferAttribute(linePositions, 3));
  lineGeo.setDrawRange(0, 0);

  const lineMat = new THREE.LineSegments(
    lineGeo,
    new THREE.LineBasicMaterial({
      color:       themeColor().line,
      transparent: true,
      opacity:     0.18
    })
  );
  scene.add(lineMat);

  /* ── MOUSE PARALLAX ─────────────────────────────────────────── */
  let mouseX = 0, mouseY = 0;
  window.addEventListener('mousemove', e => {
    mouseX = (e.clientX / window.innerWidth  - 0.5) * 0.4;
    mouseY = (e.clientY / window.innerHeight - 0.5) * 0.3;
  });

  /* ── ANIMATION LOOP ─────────────────────────────────────────── */
  let frameId;

  function animate() {
    frameId = requestAnimationFrame(animate);

    /* Move particles */
    for (let i = 0; i < PARTICLE_COUNT; i++) {
      const i3 = i * 3;
      positions[i3]     += velocities[i].x;
      positions[i3 + 1] += velocities[i].y;
      positions[i3 + 2] += velocities[i].z;

      /* Wrap around bounds */
      if (positions[i3]     >  30) positions[i3]     = -30;
      if (positions[i3]     < -30) positions[i3]     =  30;
      if (positions[i3 + 1] >  18) positions[i3 + 1] = -18;
      if (positions[i3 + 1] < -18) positions[i3 + 1] =  18;
      if (positions[i3 + 2] >  10) positions[i3 + 2] = -10;
      if (positions[i3 + 2] < -10) positions[i3 + 2] =  10;
    }
    particleGeo.attributes.position.needsUpdate = true;

    /* Build connection lines */
    let lineIdx  = 0;
    let drawCount = 0;

    outer: for (let a = 0; a < PARTICLE_COUNT; a++) {
      for (let b = a + 1; b < PARTICLE_COUNT; b++) {
        if (drawCount >= MAX_LINES) break outer;

        const ax = positions[a * 3],     ay = positions[a * 3 + 1], az = positions[a * 3 + 2];
        const bx = positions[b * 3],     by = positions[b * 3 + 1], bz = positions[b * 3 + 2];
        const dist = Math.sqrt(
          (ax - bx) ** 2 + (ay - by) ** 2 + (az - bz) ** 2
        );

        if (dist < LINE_THRESHOLD) {
          linePositions[lineIdx++] = ax;
          linePositions[lineIdx++] = ay;
          linePositions[lineIdx++] = az;
          linePositions[lineIdx++] = bx;
          linePositions[lineIdx++] = by;
          linePositions[lineIdx++] = bz;
          drawCount++;
        }
      }
    }
    lineGeo.setDrawRange(0, drawCount * 2);
    lineGeo.attributes.position.needsUpdate = true;

    /* Slow camera parallax on mouse */
    camera.position.x += (mouseX * 3 - camera.position.x) * 0.025;
    camera.position.y += (-mouseY * 2 - camera.position.y) * 0.025;
    camera.lookAt(scene.position);

    /* Gentle world rotation */
    scene.rotation.y += 0.0006;

    renderer.render(scene, camera);
  }

  animate();

  /* ── THEME CHANGE LISTENER ──────────────────────────────────── */
  const observer = new MutationObserver(() => {
    const c = themeColor();
    particleMat.color.setHex(c.node);
    lineMat.material.color.setHex(c.line);
  });
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

  /* ── REDUCED MOTION KILL SWITCH ─────────────────────────────── */
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    cancelAnimationFrame(frameId);
    renderer.render(scene, camera); // single static frame
  }

  /* ── CLEANUP (SPA navigation safety) ───────────────────────── */
  window._threeCleanup = function () {
    cancelAnimationFrame(frameId);
    observer.disconnect();
    renderer.dispose();
    particleGeo.dispose();
    particleMat.dispose();
    lineGeo.dispose();
    lineMat.material.dispose();
    window.removeEventListener('resize', resize);
  };

})();