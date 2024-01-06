SELECT * 
FROM NashvilleHousing

------- Standardise Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


------- Populate Property Address Data 


SELECT *
FROM NashvilleHousing
--- WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT *
FROM NashvilleHousing
JOIN 
