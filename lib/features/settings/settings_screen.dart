import 'package:flutter/material.dart';

import '../../core/app_data.dart';
import '../../core/user_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.app});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileUnitsSection(app: app),
        const SizedBox(height: 10),
        NotificationSection(app: app),
        const SizedBox(height: 10),
        SoundSection(app: app),
        const SizedBox(height: 10),
        AdvancedSection(app: app),
      ],
    );
  }
}


class ProfileUnitsSection extends StatelessWidget {
  const ProfileUnitsSection({super.key, required this.app});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    final p = app.userProfile;
    final nameCtrl = TextEditingController(text: p.name ?? '');
    final ageCtrl = TextEditingController(text: p.age?.toString() ?? '');
    final targetCtrl = TextEditingController(text: p.targetWeightKg?.toStringAsFixed(1) ?? '');
    final weightCtrl = TextEditingController(text: p.weightKg?.toStringAsFixed(1) ?? '');
    final heightCtrl = TextEditingController(text: p.heightCm?.toStringAsFixed(1) ?? '');
    final waistCtrl = TextEditingController(text: p.waistCm?.toStringAsFixed(1) ?? '');
    final chestCtrl = TextEditingController(text: p.chestCm?.toStringAsFixed(1) ?? '');
    final hipsCtrl = TextEditingController(text: p.hipsCm?.toStringAsFixed(1) ?? '');
    final neckCtrl = TextEditingController(text: p.neckCm?.toStringAsFixed(1) ?? '');
    return Card(
      child: ExpansionTile(
        title: const Text('Profile & Units'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (v) {
              p.name = v.trim().isEmpty ? null : v.trim();
              app.updateUserProfile(p);
            },
          ),
          TextField(
            controller: ageCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
            onChanged: (v) {
              p.age = int.tryParse(v);
              app.updateUserProfile(p);
            },
          ),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'male', label: Text('Male')), ButtonSegment(value: 'female', label: Text('Female'))],
            selected: {p.gender},
            onSelectionChanged: (v) {
              p.gender = v.first;
              app.updateUserProfile(p);
            },
          ),
          TextField(
            controller: weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Weight (kg internal)'),
            onChanged: (v) {
              p.weightKg = double.tryParse(v);
              app.updateUserProfile(p);
            },
          ),
          TextField(
            controller: heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Height (cm internal)'),
            onChanged: (v) {
              p.heightCm = double.tryParse(v);
              app.updateUserProfile(p);
            },
          ),
          TextField(controller: waistCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Waist (cm internal)'), onChanged: (v) { p.waistCm = double.tryParse(v); app.updateUserProfile(p);} ),
          TextField(controller: chestCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Chest (cm internal)'), onChanged: (v) { p.chestCm = double.tryParse(v); app.updateUserProfile(p);} ),
          TextField(controller: hipsCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Hips (cm internal)'), onChanged: (v) { p.hipsCm = double.tryParse(v); app.updateUserProfile(p);} ),
          TextField(controller: neckCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Neck (cm internal)'), onChanged: (v) { p.neckCm = double.tryParse(v); app.updateUserProfile(p);} ),
          TextField(
            controller: targetCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Target Weight (kg internal)'),
            onChanged: (v) {
              p.targetWeightKg = double.tryParse(v);
              app.updateUserProfile(p);
            },
          ),
          DropdownButtonFormField<ProfileWeightUnit>(
            value: p.units.weightUnit,
            decoration: const InputDecoration(labelText: 'Weight Unit'),
            items: ProfileWeightUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
            onChanged: (v) {
              if (v == null) return;
              p.units.weightUnit = v;
              app.updateUserProfile(p);
            },
          ),
          DropdownButtonFormField<ProfileHeightUnit>(
            value: p.units.heightUnit,
            decoration: const InputDecoration(labelText: 'Height Unit'),
            items: ProfileHeightUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
            onChanged: (v) {
              if (v == null) return;
              p.units.heightUnit = v;
              app.updateUserProfile(p);
            },
          ),
          DropdownButtonFormField<ProfileMeasurementUnit>(
            value: p.units.measurementUnit,
            decoration: const InputDecoration(labelText: 'Measurement Unit'),
            items: ProfileMeasurementUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
            onChanged: (v) {
              if (v == null) return;
              p.units.measurementUnit = v;
              app.updateUserProfile(p);
            },
          ),
        ],
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key, required this.app});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    final n = app.settings.notificationSettings;
    return Card(
      child: ExpansionTile(
        leading: const Text('🔔'),
        title: const Text('Notifications & Reminders'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          _ReminderTile(
            title: 'Morning Ritual Reminder',
            enabled: n.morningEnabled,
            time: n.morningTime,
            onChanged: (v) => app.setMorningReminder(enabled: v, time: n.morningTime),
            onPickTime: () async {
              final t = await showTimePicker(context: context, initialTime: n.morningTime ?? const TimeOfDay(hour: 8, minute: 0));
              if (t != null) app.setMorningReminder(enabled: n.morningEnabled, time: t);
            },
          ),
          _ReminderTile(
            title: 'Night Health Log Reminder',
            enabled: n.nightEnabled,
            time: n.nightTime,
            onChanged: (v) => app.setNightReminder(enabled: v, time: n.nightTime),
            onPickTime: () async {
              final t = await showTimePicker(context: context, initialTime: n.nightTime ?? const TimeOfDay(hour: 22, minute: 0));
              if (t != null) app.setNightReminder(enabled: n.nightEnabled, time: t);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Weekly Weigh-In'),
            value: n.weeklyEnabled,
            onChanged: (v) => app.setWeeklyWeighIn(enabled: v, day: n.weeklyDay, time: n.weeklyTime),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ReminderDay>(
                  value: n.weeklyDay,
                  decoration: const InputDecoration(labelText: 'Day'),
                  items: ReminderDay.values
                      .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) app.setWeeklyWeighIn(enabled: n.weeklyEnabled, day: v, time: n.weeklyTime);
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () async {
                  final t = await showTimePicker(context: context, initialTime: n.weeklyTime ?? const TimeOfDay(hour: 9, minute: 0));
                  if (t != null) app.setWeeklyWeighIn(enabled: n.weeklyEnabled, day: n.weeklyDay, time: t);
                },
                child: Text(n.weeklyTime?.format(context) ?? 'Pick Time'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Monthly Body Metrics Log'),
            value: n.monthlyEnabled,
            onChanged: (v) => app.setMonthlyMetrics(enabled: v, date: n.monthlyDate, time: n.monthlyTime),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '${n.monthlyDate}',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Date (1-28)'),
                  onChanged: (v) => app.setMonthlyMetrics(enabled: n.monthlyEnabled, date: int.tryParse(v) ?? n.monthlyDate, time: n.monthlyTime),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () async {
                  final t = await showTimePicker(context: context, initialTime: n.monthlyTime ?? const TimeOfDay(hour: 9, minute: 0));
                  if (t != null) app.setMonthlyMetrics(enabled: n.monthlyEnabled, date: n.monthlyDate, time: t);
                },
                child: Text(n.monthlyTime?.format(context) ?? 'Pick Time'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Inactivity Alert'),
            value: n.inactivityEnabled,
            onChanged: (v) => app.setInactivityAlert(enabled: v, days: n.inactivityDays),
          ),
          TextFormField(
            initialValue: '${n.inactivityDays}',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'X days', helperText: 'It has been X days since your last entry.'),
            onChanged: (v) => app.setInactivityAlert(enabled: n.inactivityEnabled, days: int.tryParse(v) ?? n.inactivityDays),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Phase Transition Reminder'),
            value: n.phaseTransitionEnabled,
            onChanged: app.setPhaseTransitionReminder,
          ),
        ],
      ),
    );
  }
}

class SoundSection extends StatelessWidget {
  const SoundSection({super.key, required this.app});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    final a = app.settings.audioSettings;
    return Card(
      child: ExpansionTile(
        leading: const Text('🎵'),
        title: const Text('Audio Experience'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('App Sound Effects'),
            value: a.appSoundEffectsEnabled,
            onChanged: app.setAppSoundEffects,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Day selection sound'),
            value: a.daySelectionSoundEnabled,
            onChanged: (v) => app.setSoundEventToggles(daySelection: v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Credit earn sound'),
            value: a.creditEarnSoundEnabled,
            onChanged: (v) => app.setSoundEventToggles(creditEarn: v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reward redeem sound'),
            value: a.rewardRedeemSoundEnabled,
            onChanged: (v) => app.setSoundEventToggles(rewardRedeem: v),
          ),
          const Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Ambient Background Sound'),
            value: a.ambientEnabled,
            onChanged: (v) => app.setAmbientSound(enabled: v, sound: a.ambientSound),
          ),
          DropdownButtonFormField<AmbientSound>(
            value: a.ambientSound,
            decoration: const InputDecoration(labelText: 'Ambient Mode'),
            items: AmbientSound.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
            onChanged: (v) {
              if (v != null) app.setAmbientSound(enabled: a.ambientEnabled, sound: v);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Haptic Feedback'),
            value: a.hapticFeedbackEnabled,
            onChanged: app.setHapticFeedback,
          ),
        ],
      ),
    );
  }
}

class AdvancedSection extends StatelessWidget {
  const AdvancedSection({super.key, required this.app});

  final AppData app;

  @override
  Widget build(BuildContext context) {
    final b = app.settings.bodybuildingMode;
    final u = app.settings.unitPreferences;

    return Card(
      child: ExpansionTile(
        leading: const Text('⚙️'),
        title: const Text('Advanced Configuration'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          const _SubHeader('Training Routine Editor'),
          ...app.settings.routineDescriptions.entries.map((entry) {
            return TextFormField(
              initialValue: entry.value,
              decoration: InputDecoration(labelText: entry.key),
              onChanged: (v) => app.updateRoutineDescription(entry.key, v),
            );
          }),
          const SizedBox(height: 12),
          const _SubHeader('Bodybuilding Mode Setup'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable Bodybuilding Mode'),
            value: b.enabled,
            onChanged: app.journey.ultimateUnlocked
                ? (v) => app.setBodybuildingSetup(enabled: v, mode: b.mode, macroPreset: b.macroPreset, calorieMultiplier: b.calorieMultiplier, workoutEmphasis: b.workoutEmphasis)
                : null,
          ),
          DropdownButtonFormField<BodybuildingSetupMode>(
            value: b.mode,
            decoration: const InputDecoration(labelText: 'Mode'),
            items: BodybuildingSetupMode.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
            onChanged: b.enabled
                ? (v) {
                    if (v != null) app.setBodybuildingSetup(enabled: b.enabled, mode: v, macroPreset: b.macroPreset, calorieMultiplier: b.calorieMultiplier, workoutEmphasis: b.workoutEmphasis);
                  }
                : null,
          ),
          TextFormField(
            initialValue: b.macroPreset,
            decoration: const InputDecoration(labelText: 'Macro percentage preset'),
            onChanged: b.enabled
                ? (v) => app.setBodybuildingSetup(enabled: b.enabled, mode: b.mode, macroPreset: v, calorieMultiplier: b.calorieMultiplier, workoutEmphasis: b.workoutEmphasis)
                : null,
          ),
          TextFormField(
            initialValue: '${b.calorieMultiplier}',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Calorie factor multiplier'),
            onChanged: b.enabled
                ? (v) => app.setBodybuildingSetup(
                      enabled: b.enabled,
                      mode: b.mode,
                      macroPreset: b.macroPreset,
                      calorieMultiplier: double.tryParse(v) ?? b.calorieMultiplier,
                      workoutEmphasis: b.workoutEmphasis,
                    )
                : null,
          ),
          TextFormField(
            initialValue: b.workoutEmphasis,
            decoration: const InputDecoration(labelText: 'Workout emphasis'),
            onChanged: b.enabled
                ? (v) => app.setBodybuildingSetup(enabled: b.enabled, mode: b.mode, macroPreset: b.macroPreset, calorieMultiplier: b.calorieMultiplier, workoutEmphasis: v)
                : null,
          ),
          const SizedBox(height: 12),
          const _SubHeader('Add Custom Reward'),
          _AddCustomRewardForm(app: app),
          const SizedBox(height: 12),
          const _SubHeader('Add Custom Self-Care Item'),
          _AddCustomSelfCareForm(app: app),
          const SizedBox(height: 8),
          ...app.settings.customRewards.map((r) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(r.title),
                subtitle: Text('${r.cost} ${r.costType.name} credit'),
              )),
          const SizedBox(height: 12),
          const _SubHeader('Import / Export'),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  final json = app.exportAllDataJson();
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('athletic_os_backup.json'),
                      content: SingleChildScrollView(child: Text(json)),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                    ),
                  );
                },
                child: const Text('Export Data'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Import Data'),
                      content: TextField(controller: controller, maxLines: 8, decoration: const InputDecoration(hintText: 'Paste backup JSON')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            final ok = app.importAllDataJson(controller.text);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Import completed' : 'Invalid backup schema')));
                          },
                          child: const Text('Overwrite Import'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Import Data'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SubHeader('Admin Overrides'),
          DropdownButtonFormField<int>(
            value: app.journey.currentPhase,
            decoration: const InputDecoration(labelText: 'Select Phase'),
            items: List.generate(6, (i) => DropdownMenuItem(value: i, child: Text('Phase $i'))),
            onChanged: (v) { if (v != null) app.setCurrentPhaseForAdmin(v); },
          ),
          DropdownButtonFormField<int>(
            value: app.currentSpiritualLevel.toInt(),
            decoration: const InputDecoration(labelText: 'Select Spiritual Level'),
            items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('Level ${i + 1}'))),
            onChanged: (v) { if (v != null) app.setCurrentSpiritualLevelForAdmin(v); },
          ),
          const SizedBox(height: 12),
          const _SubHeader('Unit Preferences'),
          DropdownButtonFormField<WeightUnit>(
            value: u.weightUnit,
            decoration: const InputDecoration(labelText: 'Weight'),
            items: WeightUnit.values.map((w) => DropdownMenuItem(value: w, child: Text(w.name))).toList(),
            onChanged: (v) => app.setUnitPreferences(weight: v),
          ),
          DropdownButtonFormField<HeightUnit>(
            value: u.heightUnit,
            decoration: const InputDecoration(labelText: 'Height'),
            items: HeightUnit.values.map((h) => DropdownMenuItem(value: h, child: Text(h.name))).toList(),
            onChanged: (v) => app.setUnitPreferences(height: v),
          ),
          DropdownButtonFormField<MeasureUnit>(
            value: u.measureUnit,
            decoration: const InputDecoration(labelText: 'Body Measurements'),
            items: MeasureUnit.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
            onChanged: (v) => app.setUnitPreferences(measure: v),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Reset Ritual Data (Current Week)?'),
                  content: const Text('This removes current-week ritual entries only.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
                  ],
                ),
              );
              if (ok == true) app.resetRitualDataCurrentWeek();
            },
            child: const Text('Reset Ritual Data (Current Week)'),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.title,
    required this.enabled,
    required this.time,
    required this.onChanged,
    required this.onPickTime,
  });

  final String title;
  final bool enabled;
  final TimeOfDay? time;
  final ValueChanged<bool> onChanged;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          value: enabled,
          onChanged: onChanged,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(onPressed: onPickTime, child: Text(time?.format(context) ?? 'Pick Time')),
        ),
      ],
    );
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _AddCustomRewardForm extends StatefulWidget {
  const _AddCustomRewardForm({required this.app});

  final AppData app;

  @override
  State<_AddCustomRewardForm> createState() => _AddCustomRewardFormState();
}

class _AddCustomRewardFormState extends State<_AddCustomRewardForm> {
  final _title = TextEditingController();
  final _cost = TextEditingController();
  final _desc = TextEditingController();
  RewardCostType _type = RewardCostType.soft;

  @override
  void dispose() {
    _title.dispose();
    _cost.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
        TextField(controller: _cost, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Credit Cost')),
        DropdownButtonFormField<RewardCostType>(
          value: _type,
          decoration: const InputDecoration(labelText: 'Soft or Big Credit'),
          items: RewardCostType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
          onChanged: (v) => setState(() => _type = v ?? RewardCostType.soft),
        ),
        TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              final title = _title.text.trim();
              final cost = int.tryParse(_cost.text) ?? 0;
              if (title.isEmpty || cost <= 0) return;
              widget.app.addCustomReward(
                title: title,
                cost: cost,
                costType: _type,
                description: _desc.text.trim(),
              );
              _title.clear();
              _cost.clear();
              _desc.clear();
            },
            child: const Text('Add Custom Reward'),
          ),
        ),
      ],
    );
  }
}

class _AddCustomSelfCareForm extends StatefulWidget {
  const _AddCustomSelfCareForm({required this.app});

  final AppData app;

  @override
  State<_AddCustomSelfCareForm> createState() => _AddCustomSelfCareFormState();
}

class _AddCustomSelfCareFormState extends State<_AddCustomSelfCareForm> {
  final _title = TextEditingController();
  final _phase = TextEditingController(text: '0');
  CustomSelfCareFrequency _freq = CustomSelfCareFrequency.daily;

  @override
  void dispose() {
    _title.dispose();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
        DropdownButtonFormField<CustomSelfCareFrequency>(
          value: _freq,
          decoration: const InputDecoration(labelText: 'Frequency'),
          items: CustomSelfCareFrequency.values.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList(),
          onChanged: (v) => setState(() => _freq = v ?? CustomSelfCareFrequency.daily),
        ),
        TextField(controller: _phase, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'requiredPhase')),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              final title = _title.text.trim();
              final phase = int.tryParse(_phase.text) ?? 0;
              if (title.isEmpty) return;
              widget.app.addCustomSelfCareItem(title: title, frequency: _freq, requiredPhase: phase);
              _title.clear();
              _phase.text = '0';
            },
            child: const Text('Add Custom Self-Care Item'),
          ),
        ),
      ],
    );
  }
}
