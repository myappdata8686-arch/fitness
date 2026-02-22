import 'physical_models.dart';

const List<String> redProtocol = <String>[
  '10 min mobility',
  'Hydration',
  'Protein',
  'Early wind-down',
  'Workout restriction',
];

const List<String> yellowProtocol = <String>[
  '10–20 min mobility',
  'Light walk',
  'Protein',
];

const List<PhysicalPhaseBlueprint> phaseBlueprints = <PhysicalPhaseBlueprint>[
  PhysicalPhaseBlueprint(
    id: 0,
    name: 'Regulation',
    successCriteria: '6 weeks to unlock manually, 8 weeks auto-transition',
    reward: '1 credit per successful week',
    requiredWalks: 4,
    requiredStrength: 2,
    allowedJunk: 2,
    greenChecklist: <String>['Mobility 20 min', 'Walk', 'Protein target', 'Sleep hygiene'],
  ),
  PhysicalPhaseBlueprint(
    id: 1,
    name: 'Foundation',
    successCriteria: 'Unlock when weight reaches 93kg',
    reward: '1 credit per kg lost',
    requiredWalks: 5,
    requiredStrength: 3,
    allowedJunk: 2,
    greenChecklist: <String>['Strength A/B split', 'Walk', 'Protein target', 'Hydration'],
  ),
  PhysicalPhaseBlueprint(
    id: 2,
    name: 'Maintenance',
    successCriteria: '8 weeks required',
    reward: '1 credit per successful week',
    requiredWalks: 5,
    requiredStrength: 3,
    allowedJunk: 3,
    greenChecklist: <String>['Strength', 'Walk', 'Mobility', 'Recovery routine'],
  ),
  PhysicalPhaseBlueprint(
    id: 3,
    name: 'Recomposition',
    successCriteria: 'Unlock at 83kg OR waist 34 inches',
    reward: '1 credit per kg lost',
    requiredWalks: 5,
    requiredStrength: 4,
    allowedJunk: 2,
    greenChecklist: <String>['Progressive overload', 'Walk', 'Mobility', 'High protein'],
  ),
  PhysicalPhaseBlueprint(
    id: 4,
    name: 'Forever',
    successCriteria: '12 months required',
    reward: '1 credit per successful week + major reward at completion',
    requiredWalks: 5,
    requiredStrength: 3,
    allowedJunk: 3,
    greenChecklist: <String>['Sustainable strength', 'Walk', 'Mobility', 'Recovery'],
  ),
];
