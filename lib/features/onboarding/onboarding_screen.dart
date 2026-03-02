import 'package:flutter/material.dart';

import '../../core/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinish, required this.onSkipAll});

  final ValueChanged<UserProfile> onFinish;
  final VoidCallback onSkipAll;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  final profile = UserProfile();

  final _name = TextEditingController();
  final _age = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _waist = TextEditingController();
  final _chest = TextEditingController();
  final _hips = TextEditingController();
  final _neck = TextEditingController();
  final _target = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _age, _weight, _height, _waist, _chest, _hips, _neck, _target]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: switch (step) {
          0 => _greeting(),
          1 => _basicInfo(),
          2 => _bodyMetrics(),
          _ => _targetUnits(),
        },
      ),
    );
  }

  Widget _greeting() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(45))),
          const SizedBox(height: 18),
          const Text('As-salamu alaikum.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('I will walk this journey with you.'),
          const SizedBox(height: 22),
          ElevatedButton(onPressed: () => setState(() => step = 1), child: const Text('Begin')),
          TextButton(onPressed: widget.onSkipAll, child: const Text('Skip all')),
        ],
      );

  Widget _basicInfo() => ListView(children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name (optional)')),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [ButtonSegment(value: 'male', label: Text('Male')), ButtonSegment(value: 'female', label: Text('Female'))],
          selected: {profile.gender},
          onSelectionChanged: (v) => setState(() => profile.gender = v.first),
        ),
        const SizedBox(height: 8),
        TextField(controller: _age, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age (optional)')),
        const SizedBox(height: 12),
        Row(children: [
          TextButton(onPressed: () => setState(() => step = 2), child: const Text('Skip')),
          const Spacer(),
          ElevatedButton(onPressed: () {
            profile.name = _name.text.trim().isEmpty ? null : _name.text.trim();
            profile.age = int.tryParse(_age.text);
            setState(() => step = 2);
          }, child: const Text('Continue')),
        ])
      ]);

  Widget _bodyMetrics() => ListView(children: [
        Row(children: [
          Expanded(child: TextField(controller: _weight, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Weight (${profile.units.weightUnit.name})'))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: _height, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Height (${profile.units.heightUnit.name})'))),
        ]),
        TextField(controller: _waist, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Waist (${profile.units.measurementUnit.name})')),
        TextField(controller: _chest, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Chest (${profile.units.measurementUnit.name})')),
        TextField(controller: _hips, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Hips (${profile.units.measurementUnit.name})')),
        TextField(controller: _neck, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Neck (${profile.units.measurementUnit.name})')),
        const SizedBox(height: 12),
        Row(children: [
          TextButton(onPressed: () => setState(() => step = 3), child: const Text('Skip')),
          const Spacer(),
          ElevatedButton(onPressed: () {
            _saveBodyMetrics();
            setState(() => step = 3);
          }, child: const Text('Save & Continue')),
        ])
      ]);

  Widget _targetUnits() => ListView(children: [
        TextField(controller: _target, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Target Weight (${profile.units.weightUnit.name})')),
        DropdownButtonFormField<ProfileWeightUnit>(
          value: profile.units.weightUnit,
          decoration: const InputDecoration(labelText: 'Weight Unit'),
          items: ProfileWeightUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
          onChanged: (v) => setState(() => profile.units.weightUnit = v ?? ProfileWeightUnit.kg),
        ),
        DropdownButtonFormField<ProfileHeightUnit>(
          value: profile.units.heightUnit,
          decoration: const InputDecoration(labelText: 'Height Unit'),
          items: ProfileHeightUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
          onChanged: (v) => setState(() => profile.units.heightUnit = v ?? ProfileHeightUnit.ftIn),
        ),
        DropdownButtonFormField<ProfileMeasurementUnit>(
          value: profile.units.measurementUnit,
          decoration: const InputDecoration(labelText: 'Measurement Unit'),
          items: ProfileMeasurementUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
          onChanged: (v) => setState(() => profile.units.measurementUnit = v ?? ProfileMeasurementUnit.inches),
        ),
        const SizedBox(height: 12),
        Row(children: [
          TextButton(onPressed: _finishSkip, child: const Text('Skip')),
          const Spacer(),
          ElevatedButton(onPressed: _finishSave, child: const Text('Finish')),
        ])
      ]);

  void _saveBodyMetrics() {
    final w = double.tryParse(_weight.text);
    final h = double.tryParse(_height.text);
    if (w != null) {
      final kg = toKg(w, profile.units.weightUnit);
      if (isRealisticWeightKg(kg)) profile.weightKg = kg;
    }
    if (h != null) {
      final cm = toCmFromHeight(h, profile.units.heightUnit);
      if (isRealisticHeightCm(cm)) profile.heightCm = cm;
    }
    profile.waistCm = _parseMeasure(_waist.text);
    profile.chestCm = _parseMeasure(_chest.text);
    profile.hipsCm = _parseMeasure(_hips.text);
    profile.neckCm = _parseMeasure(_neck.text);
  }

  double? _parseMeasure(String text) {
    final v = double.tryParse(text);
    if (v == null) return null;
    return toCmMeasure(v, profile.units.measurementUnit);
  }

  void _finishSave() {
    _saveBodyMetrics();
    final t = double.tryParse(_target.text);
    if (t != null) profile.targetWeightKg = toKg(t, profile.units.weightUnit);
    profile.recomputeCompleteness();
    widget.onFinish(profile);
  }

  void _finishSkip() {
    profile.recomputeCompleteness();
    widget.onFinish(profile);
  }
}
