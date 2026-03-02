import 'murshid_context.dart';

class MurshidLocalEngine {
  String respond(MurshidContext c) {
    if (c.defenseActive) {
      return 'As-salamu alaikum. Your system is in defense mode. Keep structure simple: steady meals, calm training, and recovery-first discipline this week.';
    }
    if (c.belowFloor) {
      return 'Bismillah. This is a reset week: protect the floor first—walking, strength, and fewer junk exposures. Rebuild rhythm before intensity.';
    }
    if (c.aboveCeiling) {
      return 'Alhamdulillah for awareness. We recalibrate today: reduce drift, restore routine anchors, and bring choices back inside your ceiling.';
    }
    if (c.stabilityMastery) {
      return 'MashaAllah, your stability mastery is showing. Reflect on what made this streak sustainable, then preserve those anchors with humility.';
    }
    if (c.vertigoActive || c.illnessActive || (c.bloodPressure != null && c.bloodPressure! > 130)) {
      return 'I am with you. Prioritize rest, hydration, and safe movement only. If symptoms persist, please consult your clinician.';
    }
    return 'InshaAllah, stay consistent today: one disciplined training action, one clean nutrition decision, and one spiritual anchor.';
  }
}
