SELECT * 
FROM dbo.[Nashville Housing]

----------------------------------------------------------------------------------------------------------------------------

--- Standardise Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.[Nashville Housing]

UPDATE dbo.[Nashville Housing]
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE dbo.[Nashville Housing]
ADD SaleDateConverted Date;

UPDATE dbo.[Nashville Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


-------------------------------------------------------------------------------------------------------------------------------

--- Populate Property Address Data 

SELECT *
FROM dbo.[Nashville Housing]
--- WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM dbo.[Nashville Housing] a
JOIN dbo.[Nashville Housing] b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM dbo.[Nashville Housing] a
JOIN dbo.[Nashville Housing] b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


-------------------------------------------------------------------------------------------------------------------------

---- Splitting Address into individual columns (Address, City, State)

Select PropertyAddress
FROM dbo.[Nashville Housing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM dbo.[Nashville Housing]

ALTER TABLE dbo.[Nashville Housing]
ADD PropertySplitAddress Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE dbo.[Nashville Housing]
ADD PropertySplitCity Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 



-------------------------------------------------------------------------------------------------------------------------

--- Splitting Owner address into three columnns

SELECT OwnerAddress
FROM dbo.[Nashville Housing]

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM dbo.[Nashville Housing]


ALTER TABLE dbo.[Nashville Housing]
ADD OwnerSplitAddress Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE dbo.[Nashville Housing]
ADD OwnerSplitCity Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE dbo.[Nashville Housing]
ADD OwnerSplitState Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1) 


--------------------------------------------------------------------------------------------------------------------------

--- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant)
FROM dbo.[Nashville Housing]

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM dbo.

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   
-----------------------------------------------------------------------------------------------------------------------------

--- Remove Duplicates 

WITH RowNumCTE AS(
SELECT *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress, 
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			      UniqueID
				  ) row_num

FROM dbo.[Nashville Housing]
-- ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--- ORDER BY PropertyAddress


--------------------------------------------------------------------------------------------------------------------------------

--- Delete unused columns 

SELECT * 
FROM dbo.[Nashville Housing]

ALTER TABLE dbo.[Nashville Housing]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

ALTER TABLE dbo.[Nashville Housing]
DROP COLUMN SaleDate
