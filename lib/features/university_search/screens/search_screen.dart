import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../l10n/l10n.dart';
import '../cubit/university_search_cubit.dart';
import '../cubit/university_search_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/university_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final UniversitySearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = UniversitySearchCubit()..loadInitial();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _cubit, child: const _SearchScreenView());
  }
}

class _SearchScreenView extends StatelessWidget {
  const _SearchScreenView();

  void _openFilter(BuildContext context, String type) async {
    final cubit = context.read<UniversitySearchCubit>();
    final state = cubit.state;

    final results = await FilterBottomSheet.show(
      context,
      major: state.selectedMajor,
      location: state.selectedLocation,
      budget: state.maxBudget,
      scholarship: state.scholarshipRequired,
    );

    if (results != null) {
      cubit.applyFilters(
        major: results['major'],
        location: results['location'],
        budgetMax: results['budgetMax'],
        scholarshipRequired: results['scholarshipRequired'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.findUniversity),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D0D9488),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) =>
                    context.read<UniversitySearchCubit>().search(v),
                decoration: InputDecoration(
                  hintText: l10n.searchUniversities,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.outline,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.filterMajor,
                  isActive: context.select(
                    (UniversitySearchCubit c) => c.state.selectedMajor != null,
                  ),
                  onTap: () => _openFilter(context, 'major'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.filterLocation,
                  isActive: context.select(
                    (UniversitySearchCubit c) =>
                        c.state.selectedLocation != null,
                  ),
                  onTap: () => _openFilter(context, 'location'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.filterBudget,
                  isActive: context.select(
                    (UniversitySearchCubit c) => c.state.maxBudget != null,
                  ),
                  onTap: () => _openFilter(context, 'budget'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.filterScholarship,
                  isActive: context.select(
                    (UniversitySearchCubit c) => c.state.scholarshipRequired,
                  ),
                  onTap: () => _openFilter(context, 'scholarship'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List
          Expanded(
            child: BlocBuilder<UniversitySearchCubit, UniversitySearchState>(
              builder: (context, state) {
                if (state.status == UniversitySearchStatus.loading &&
                    state.universities.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == UniversitySearchStatus.error) {
                  return ErrorView(
                    message: state.errorMessage ?? 'An error occurred',
                    onRetry: () =>
                        context.read<UniversitySearchCubit>().loadInitial(),
                  );
                } else if (state.universities.isEmpty) {
                  return EmptyState(
                    title: 'No universities found',
                    subtitle: 'Try adjusting your search criteria',
                  );
                }

                // loaded or loading with existing data
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    100,
                  ), // extra padding at bottom
                  itemCount:
                      state.universities.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.universities.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                            ),
                            onPressed:
                                state.status == UniversitySearchStatus.loading
                                ? null
                                : () => context
                                      .read<UniversitySearchCubit>()
                                      .loadMore(),
                            child:
                                state.status == UniversitySearchStatus.loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.onPrimary,
                                    ),
                                  )
                                : Text(l10n.loadMore),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: UniversityCard(
                        university: state.universities[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryContainer
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primaryContainer
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.onPrimaryContainer
                    : AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 18,
              color: isActive
                  ? AppColors.onPrimaryContainer
                  : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
