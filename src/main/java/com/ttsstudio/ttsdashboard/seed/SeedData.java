package com.ttsstudio.ttsdashboard.seed;

/**
 * SeedData.java
 *
 * ─────────────────────────────────────────────────────────────────
 * PHASE 1 (Current):
 *   All dashboard data is hardcoded in:
 *   src/main/webapp/static/js/seed-data.js
 *
 *   No database connection is needed.
 *   This class is intentionally empty in Phase 1.
 *
 * ─────────────────────────────────────────────────────────────────
 * PHASE 2 (Future — when MySQL is connected):
 *
 *   Steps to activate:
 *   1. Add spring-boot-starter-data-jpa to pom.xml
 *   2. Add MySQL connector dependency to pom.xml
 *   3. Update application.properties with DB credentials
 *   4. Create entity classes (Dataset, AudioClip, Speaker, etc.)
 *   5. Create JPA repositories for each entity
 *   6. Uncomment the Phase 2 block below and wire in repositories
 *
 * ─────────────────────────────────────────────────────────────────
 * PHASE 2 TEMPLATE (uncomment when ready):
 *
 *  @Component
 *  public class SeedData implements CommandLineRunner {
 *
 *      @Autowired private DatasetRepository datasetRepo;
 *      @Autowired private SpeakerRepository speakerRepo;
 *      @Autowired private TrainingJobRepository trainingRepo;
 *      @Autowired private ModelEvaluationRepository evalRepo;
 *      @Autowired private VoiceRepository voiceRepo;
 *
 *      @Override
 *      public void run(String... args) throws Exception {
 *
 *          // Only seed if tables are empty
 *          if (datasetRepo.count() == 0) {
 *              datasetRepo.save(new Dataset(
 *                  "ds_hi_001",
 *                  "Hindi Female Support Dataset",
 *                  "Hindi", "hi", "North Indian",
 *                  "recorded", "Internal Recording",
 *                  "approved", 120.5, 87.2, 42000, 35,
 *                  "approved", "data_ops_01"
 *              ));
 *              // ... add more datasets
 *          }
 *
 *          if (speakerRepo.count() == 0) {
 *              speakerRepo.save(new Speaker(
 *                  "spk_hi_f_001", "Speaker 001",
 *                  "female", "Hindi", "North Indian",
 *                  4.5, 91, "approved", true
 *              ));
 *              // ... add more speakers
 *          }
 *
 *          if (trainingRepo.count() == 0) {
 *              trainingRepo.save(new TrainingJob(
 *                  "train_xtts_hi_001", "ds_hi_001",
 *                  "XTTS-v2", "hi", "fine_tune",
 *                  "H100", 1, 16, 0.00001, 50,
 *                  "running", 18, 0.92, 1.04
 *              ));
 *              // ... add more jobs
 *          }
 *      }
 *  }
 * ─────────────────────────────────────────────────────────────────
 */
public class SeedData {
    // Phase 1: intentionally empty
    // Phase 2: implement CommandLineRunner (see template above)
}
