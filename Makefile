include $(TOPDIR)/rules.mk 

PKG_NAME:=squidGuard
PKG_VERSION:=1.6.0-1
PKG_RELEASE:=2
PKG_LICENSE:=GNU
PKG_MAINTAINER:=Ivan Ivanov <andrroidtex@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://salsa.debian.org/joowie-guest/maintain_squidguard.git
PKG_SOURCE_VERSION:=7b373fffa224c6a350553d8f9f4aef9cd7a125bf
PKG_MIRROR_HASH:=97a023caada7506d7dde0a0169215c5b0f81ec89b80ed10b1e8fff445ccaaeec
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
  DEPENDS:=+libdb47 +libpthread +glib2 +squid
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

define Build/Configure
	( cd $(PKG_BUILD_DIR); ./autogen.sh)
	$(call Build/Configure/Default,$CONFIGURE_ARGS)
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)"
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" install 
endef

define Package/squidGuard/install
	$(INSTALL_DIR) $(1)/opt/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/squidGuard $(1)/opt/sbin

	$(INSTALL_DIR) $(1)/opt/etc/squidguard
	$(INSTALL_CONF) ./files/squidGuard.conf $(1)/opt/etc/squidguard/squidGuard.conf

	$(INSTALL_DIR) $(1)/opt/usr/squidguard/db/blacklist
	$(CP) $(PKG_BUILD_DIR)/test/blacklist/* $(1)/opt/usr/squidguard/db/blacklist
	
	$(INSTALL_DIR) $(1)/opt/var/log/squidguard

endef

$(eval $(call BuildPackage,squidGuard))
