package org.yafra.orm.auto;

import java.util.List;

import org.apache.cayenne.CayenneDataObject;
import org.yafra.orm.YafraAudit;
import org.yafra.orm.YafraBusinessRole;

/**
 * Class _YafraUser was generated by Cayenne.
 * It is probably a good idea to avoid changing this class manually,
 * since it may be overwritten next time code is regenerated.
 * If you need to make any customizations, please use subclass.
 */
public abstract class _YafraUser extends CayenneDataObject {

    public static final String NAME_PROPERTY = "name";
    public static final String PICTURELINK_PROPERTY = "picturelink";
    public static final String USERID_PROPERTY = "userid";
    public static final String YROLES_PROPERTY = "YRoles";
    public static final String AUDIT_ARRAY_PROPERTY = "auditArray";

    public static final String PK_YAFRA_USER_PK_COLUMN = "pkYafraUser";

    public void setName(String name) {
        writeProperty("name", name);
    }
    public String getName() {
        return (String)readProperty("name");
    }

    public void setPicturelink(String picturelink) {
        writeProperty("picturelink", picturelink);
    }
    public String getPicturelink() {
        return (String)readProperty("picturelink");
    }

    public void setUserid(String userid) {
        writeProperty("userid", userid);
    }
    public String getUserid() {
        return (String)readProperty("userid");
    }

    public void addToYRoles(YafraBusinessRole obj) {
        addToManyTarget("YRoles", obj, true);
    }
    public void removeFromYRoles(YafraBusinessRole obj) {
        removeToManyTarget("YRoles", obj, true);
    }
    @SuppressWarnings("unchecked")
    public List<YafraBusinessRole> getYRoles() {
        return (List<YafraBusinessRole>)readProperty("YRoles");
    }


    public void addToAuditArray(YafraAudit obj) {
        addToManyTarget("auditArray", obj, true);
    }
    public void removeFromAuditArray(YafraAudit obj) {
        removeToManyTarget("auditArray", obj, true);
    }
    @SuppressWarnings("unchecked")
    public List<YafraAudit> getAuditArray() {
        return (List<YafraAudit>)readProperty("auditArray");
    }


}
