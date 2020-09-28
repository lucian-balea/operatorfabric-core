/* Copyright (c) 2018-2020, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 * This file is part of the OperatorFabric project.
 */

package org.lfenergy.operatorfabric.cards.publication.services;

import org.lfenergy.operatorfabric.aop.process.mongo.models.UserActionTraceData;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface TraceReposiory extends ReactiveMongoRepository<UserActionTraceData,String> {
    Mono<UserActionTraceData> findByCardUid(String cardUid);
    Mono<UserActionTraceData> findByCardUidAndActionAndUserName(String cardUid,String action,String userName);
    Mono<UserActionTraceData> findByCardUidAndAction(String cardUid,String action);
}