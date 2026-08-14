# Implementation Plan - API Loader and Multi-click Prevention

This plan addresses the issue where loaders are not consistently visible and users can trigger multiple API calls by clicking buttons repeatedly.

## Proposed Changes

### Core Network Layer

#### [api_service.dart](file:///Users/techwinlabs/Desktop/AakashWorkspace/FlutterWorkspace/play_store_copy_app/rosewe_online_shopping/lib/core/network/api_service.dart)
- Add a static flag `_isRequestInProgress` to track active requests.
- Update `get`, `post`, `put`, `delete`, `formPost`, and `formPut` methods to check this flag before proceeding.
- If a request is already in progress, ignore subsequent calls to prevent duplicate API hits.

#### [common_methods.dart](file:///Users/techwinlabs/Desktop/AakashWorkspace/FlutterWorkspace/play_store_copy_app/rosewe_online_shopping/lib/core/utils/common_methods.dart)
- Ensure `showLoader` is called with `useRootNavigator: true` if using GetX dialogs to ensure it overlays everything. (Already improved visibility in previous turn).

### UI Components

#### [custom_button.dart](file:///Users/techwinlabs/Desktop/AakashWorkspace/FlutterWorkspace/play_store_copy_app/rosewe_online_shopping/lib/widgets/buttons/custom_button.dart)
- Research if `CustomButton` can be updated to automatically disable itself when an API call is in progress.

## Verification Plan

### Manual Verification
- Test Login screen: Click login button multiple times rapidly and verify only one API call is made (check logs).
- Test Account Delete screen: Verify "Next" button only triggers one deletion request.
- Verify loader is clearly visible and blocks UI interaction.
