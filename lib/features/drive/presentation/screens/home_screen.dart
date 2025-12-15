import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/core/router/app_router.dart';
import 'package:driver_app/features/drive/domain/entities/job.dart';
import 'package:driver_app/features/drive/presentation/providers/job_provider.dart';
import 'package:driver_app/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildJobList(List<Job> jobs, JobStatus status) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              status == JobStatus.pending
                  ? HeroIcons.clock
                  : status == JobStatus.ongoing
                      ? HeroIcons.truck
                      : HeroIcons.checkBadge,
              size: AppSizes.iconMain,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              status == JobStatus.pending
                  ? AppStrings.noPendingJobs
                  : status == JobStatus.ongoing
                      ? AppStrings.noOngoingJobs
                      : AppStrings.noCompletedJobs,
              style: TextStyle(
                fontSize: AppSizes.fontL,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingL),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(Job job) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.paddingL),
      elevation: 2,
      child: InkWell(
        onTap: () => context.push(Routes.jobWithId(job.id)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: AppSizes.fontXL,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Row(
                          children: [
                            HeroIcon(
                              HeroIcons.buildingOffice, 
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: AppSizes.iconL, 
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Text(
                              job.customerName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: AppSizes.fontL,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(job.status),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  HeroIcon(
                    HeroIcons.mapPin,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: AppSizes.iconL,
                    style: HeroIconStyle.solid,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '${job.totalStops} ${AppStrings.stop}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (job.isOngoing) ...[
                    const SizedBox(width: AppSizes.paddingL),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: job.progress,
                        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.secondary
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingL),
                    Text(
                      '${job.completedStopsCount}/${job.totalStops}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  HeroIcon(
                    job.status == JobStatus.pending
                        ? HeroIcons.clock
                        : job.status == JobStatus.ongoing
                            ? HeroIcons.truck
                            : HeroIcons.checkBadge,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    size: AppSizes.iconL,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    job.status == JobStatus.pending
                        ? '${AppStrings.createdAt} ${dateFormat.format(job.createdAt)}'
                        : job.status == JobStatus.ongoing
                            ? '${AppStrings.startedAt} ${dateFormat.format(job.startedAt!)}'
                            : '${AppStrings.completedAt} ${dateFormat.format(job.completedAt!)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: AppSizes.fontM,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(JobStatus status) {
    Color color;
    String text;
    HeroIcons icon;

    switch (status) {
      case JobStatus.pending:
        color = Theme.of(context).colorScheme.errorContainer;
        text = AppStrings.pending;
        icon = HeroIcons.clock;
        break;
      case JobStatus.ongoing:
        color = Theme.of(context).colorScheme.secondary;
        text = AppStrings.ongoing;
        icon = HeroIcons.truck;
        break;
      case JobStatus.completed:
        color = Theme.of(context).colorScheme.tertiary;
        text = AppStrings.completed;
        icon = HeroIcons.checkBadge;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingXS,
        horizontal: AppSizes.paddingS, 
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: color, 
          width: 1
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon, 
            color: color,
            size: AppSizes.iconL, 
          ),
          const SizedBox(width: AppSizes.paddingXS),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: AppSizes.fontM,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Tab _buildMenuTab(String label) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: AppSizes.fontL,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingJobs = ref.watch(pendingJobsProvider);
    final ongoingJobs = ref.watch(ongoingJobsProvider);
    final completedJobs = ref.watch(completedJobsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          AppStrings.appName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL,
            fontWeight: FontWeight.w900,
            fontFamily: 'cursive'
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            child: GestureDetector(
              onTap: () => ref.read(themeProvider.notifier).toggle(),
              child: HeroIcon(
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? HeroIcons.sun
                    : HeroIcons.moon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSizes.iconL,
                style: HeroIconStyle.solid,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildMenuTab(AppStrings.pending),
            _buildMenuTab(AppStrings.ongoing),
            _buildMenuTab(AppStrings.completed),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList(pendingJobs, JobStatus.pending),
          _buildJobList(ongoingJobs, JobStatus.ongoing),
          _buildJobList(completedJobs, JobStatus.completed),
        ],
      ),
    );
  }
}