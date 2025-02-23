if exists (select * from dbo.sysobjects where id = object_id(N'[FK_Photos_Ads]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [Photos] DROP CONSTRAINT FK_Photos_Ads
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_SavedAds_Ads]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [SavedAds] DROP CONSTRAINT FK_SavedAds_Ads
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_Ads_Categories]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [Ads] DROP CONSTRAINT FK_Ads_Categories
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_Categories_Categories]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [Categories] DROP CONSTRAINT FK_Categories_Categories
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_Ads_Members]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [Ads] DROP CONSTRAINT FK_Ads_Members
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_SavedAds_Members]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [SavedAds] DROP CONSTRAINT FK_SavedAds_Members
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[AdDeleted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [AdDeleted]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[AdInserted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [AdInserted]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[AdUpdated]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [AdUpdated]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OnCategoryInsert]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [OnCategoryInsert]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountAdResponsesByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountAdResponsesByStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountAdViewsByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountAdViewsByStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountAdsByCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountAdsByCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountAdsByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountAdsByStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountLocations]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountLocations]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountMembersByDateRange]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountMembersByDateRange]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CountTopCategories]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CountTopCategories]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[CreateCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CreateCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ExpireAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [ExpireAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetAdById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetAdById]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetAdsByRandomOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetAdsByRandomOrder]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetAdsByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetAdsByStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetAllAdsByQuery]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetAllAdsByQuery]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetAllLocations]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetAllLocations]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetCategoriesByParentId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetCategoriesByParentId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetCategoryById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetCategoryById]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetExpiredAds]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetExpiredAds]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetMemberByUsername]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetMemberByUsername]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetParentCategoriesById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetParentCategoriesById]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetPhotoById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetPhotoById]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetPhotoBytesById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetPhotoBytesById]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetPhotosByAdId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetPhotosByAdId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetPhotosByAdStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetPhotosByAdStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[GetSavedAds]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [GetSavedAds]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertLocation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertMember]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertMember]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertPhoto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertPhoto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[InsertSavedAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [InsertSavedAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[MoveAds]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [MoveAds]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[MoveCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [MoveCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RelistAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RelistAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemoveAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemoveAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemoveAdsByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemoveAdsByStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemoveCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemoveCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemoveLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemoveLocation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemovePhoto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemovePhoto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemovePhotosByAdStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemovePhotosByAdStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[RemoveSavedAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [RemoveSavedAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SetAdPreviewPhoto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [SetAdPreviewPhoto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateAd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateAd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateAdCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateAdCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateAdLevel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateAdLevel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateAdStats]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateAdStats]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateAdStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateAdStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateCategoryAdCounts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateCategoryAdCounts]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateCategoryName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateCategoryName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[UpdateLocation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [UpdateLocation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ClassifiedsView_Ads]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [ClassifiedsView_Ads]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[PhotosView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [PhotosView]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Ads]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Ads]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Categories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Categories]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Locations]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Locations]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Members]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Members]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Photos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Photos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SavedAds]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [SavedAds]
GO