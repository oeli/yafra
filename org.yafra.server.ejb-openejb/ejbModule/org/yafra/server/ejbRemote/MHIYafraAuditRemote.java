/*****************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.yafra.server.ejbRemote;

import java.util.List;

import org.yafra.model.MYafraAudit;
import org.yafra.model.MYafraUser;

/**
 * model handler remote implementation</br>
 * 
 * @see org.yafra.interfaces.IYafraMHIYafraRole
 * @version $Id: MHIYafraRoleRemote.java,v 1.1 2009-12-12 21:41:32 mwn Exp $
 * @author <a href="mailto:yafra@yafra.org">Martin Weber</a>
 * @since 1.0
 */
public interface MHIYafraAuditRemote {
	/**
	 * insert a new role
	 * @param mya role to be inserted
	 * @param m role to be inserted
	 */
	public void insertYafraAudit(MYafraAudit mya, MYafraUser myu);

	/**
	 * delete a role
	 * @param id name of the role to be deleted
	 */
	public void deleteYafraAudit(Integer id);

	/**
	 * get business roles to role
	 * @param id of the business role
	 * @return
	 */
	public List<MYafraAudit> getYafraAudit(MYafraUser myu);
	/**
	 * insert a new role
	 * @param name name of the role
	 * @return 1 model object
	 */

}
