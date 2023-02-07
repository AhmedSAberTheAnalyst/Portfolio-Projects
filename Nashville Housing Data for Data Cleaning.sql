-- Cleaning Data Using SQl Project

SELECT *
FROM
[SQL Project 3]..NashvilleHousing

-- Standarize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM
[SQL Project 3]..NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate property Address Data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
[SQL Project 3]..NashvilleHousing a
JOIN [SQL Project 3]..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress		is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
[SQL Project 3]..NashvilleHousing a
JOIN [SQL Project 3]..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress		is null

-- Breaking Out Address Into Indvidual Columns (Adress, City, State)

SELECT PropertyAddress
FROM
[SQL Project 3]..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

FROM
[SQL Project 3]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM
[SQL Project 3]..NashvilleHousing


SELECT OwnerAddress
FROM
[SQL Project 3]..NashvilleHousing


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM
[SQL Project 3]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM
[SQL Project 3]..NashvilleHousing


-- Change Y and N to Yes and NO in "Sold as Vacant" Field	

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM
[SQL Project 3]..NashvilleHousing
Group by SoldAsVacant
Order by 2


SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'YES'
      When SoldAsVacant = 'N' then 'NO'
	  ELSE SoldAsVacant
	  END
FROM
[SQL Project 3]..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'YES'
      When SoldAsVacant = 'N' then 'NO'
	  ELSE SoldAsVacant
	  END


-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [SQL Project 3].dbo.NashvilleHousing
--order by ParcelID
)
DELETE -- We Change it to Select To Check 
FROM RowNumCTE
WHERE row_num >1

-- Delete Unused Columns

SELECT *
FROM
[SQL Project 3]..NashvilleHousing

ALTER TABLE [SQL Project 3]..NashvilleHousing

DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE [SQL Project 3]..NashvilleHousing

DROP COLUMN SaleDate






