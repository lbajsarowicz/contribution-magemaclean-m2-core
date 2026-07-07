# Installation guide — MageMaclean Core

**Product version:** 1.0.5  
**Composer package:** `magemaclean/m2-core`  
**Magento module:** `MageMaclean_Core`

MageMaclean Core is a **free shared dependency** required by MageMaclean paid extensions. Install it before (or with) any MageMaclean feature module.

## Requirements

| Requirement | Version |
|-------------|---------|
| Magento Open Source / Adobe Commerce | 2.4.7+ |
| PHP | 8.1 – 8.5 |

## Install via Composer (recommended)

```bash
composer require magemaclean/m2-core
php bin/magento setup:upgrade
php bin/magento cache:flush
```

Production mode:

```bash
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy
```

## Manual installation

1. Extract module files to `app/code/MageMaclean/Core/`
2. Run:

```bash
php bin/magento setup:upgrade
php bin/magento cache:flush
```

## Verify

```bash
php bin/magento module:status MageMaclean_Core
```

Admin should show a **MageMaclean** menu tab (child modules add entries under it).

## Upgrade

```bash
composer update magemaclean/m2-core
php bin/magento setup:upgrade
php bin/magento cache:flush
```

## Support

Email: support@magemaclean.com
