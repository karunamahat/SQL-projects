								--DATA CLEANING--
SELECT *
FROM Project1.dbo.NashvilleHousing

-- STANDARD DATE FORMAT 
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Project1.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate) 

--Populating property address
SELECT *
FROM Project1.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Project1.dbo.NashvilleHousing AS A
JOIN Project1.dbo.NashvilleHousing AS B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID]<>B.[UniqueID]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress= ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Project1.dbo.NashvilleHousing AS A
JOIN Project1.dbo.NashvilleHousing AS B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID]<>B.[UniqueID]

--BREAKING OUT ADDRESS
SELECT PropertyAddress
FROM Project1.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address

FROM Project1.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) 

SELECT *
FROM NashvilleHousing


--Cleaning owner address
SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM NashvilleHousing

--Change SoldAsVacant column to YES and NO
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
Order BY 2

UPDATE NashvilleHousing
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = '0' THEN 0
        WHEN SoldAsVacant = '1' THEN 1
        ELSE SoldAsVacant
    END
ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(10)


SELECT SoldAsVacant
, CASE 
        WHEN SoldAsVacant = 0 THEN 'No'
        WHEN SoldAsVacant = 1 THEN 'Yes'
        ELSE SoldAsVacant
    END
FROM NashVilleHousing

UPDATE NashVilleHousing
SET SoldAsVacant= CASE 
        WHEN SoldAsVacant = 0 THEN 'No'
        WHEN SoldAsVacant = 1 THEN 'Yes'
        ELSE SoldAsVacant
    END


--Removing Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) row_num
FROM NashVilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
WHERE row_num>1

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) row_num
FROM NashVilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
WHERE row_num>1
order by PropertyAddress


--Deleting Unused Columns

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SoldAsVacant_New
