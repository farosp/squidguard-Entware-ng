include $(TOPDIR)/rules.mk 

PKG_NAME:=squidGuard
PKG_VERSION:=1.5-beta
PKG_RELEASE:=2
PKG_LICENSE:=GNU
PKG_MAINTAINER:=Ivan Ivanov <andrroidtex@gmail.com>
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.squidguard.org/Downloads/Devel/
PKG_MD5SUM:=85216992d14acb29d6f345608f21f268 

PKG_BUILD_PARALLEL:=1 
PKG_INSTALL:=1 

include $(INCLUDE_DIR)/package.mk 

define Package/squidGuard/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  URL:=http://www.squidguard.org/ 
endef 

define Package/squidGuard
  $(call Package/squidGuard/Default)
  MENU:=1
  DEPENDS:=+libdb47 +libpthread +glib2
  TITLE:=Combined filter, redirector and access controller plugin for Squid endef define Package/squidguard/description SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid. There are two big advantages to squidguard: it is fast and it is free. 
endef 

CONFIGURE_ARGS += \
	--sysconfdir=/opt/etc/squidguard \
	--with-db-inc= /opt/lib \
	--datadir=/opt/share/squidguard \
	--datarootdir=/opt/usr/squidguard \
	--datadir=/opt/usr/squidguard \
	--with-sg-dbhome=/opt/usr/squidguard/db \
	--with-sg-logdir=/opt/var/log/squidguard \
	--with-sg-config=/opt/etc/squidguard/squidguard.conf \
	--with-squiduser=nobody 


define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" all
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" install 
endef

define Package/squidGuard/install
	$(INSTALL_DIR) $(1)/opt/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/squidGuard $(1)/opt/sbin

	$(INSTALL_DIR) $(1)/opt/etc/squidguard
	$(INSTALL_CONF) ./files/squidguard.conf $(1)/opt/etc/squidguard/squidguard.conf

	$(INSTALL_DIR) $(1)/opt/usr/squidguard/db/blacklist
	$(CP) $(PKG_BUILD_DIR)/test/blacklist/* $(1)/opt/usr/squidguard/db/blacklist
	
	$(INSTALL_DIR) $(1)/opt/var/log/squidguard

endef

$(eval $(call BuildPackage,squidGuard))
