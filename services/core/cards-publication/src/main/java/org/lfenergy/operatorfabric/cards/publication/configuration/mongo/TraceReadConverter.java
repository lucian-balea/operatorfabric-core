/* Copyright (c) 2018-2020, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 * This file is part of the OperatorFabric project.
 */

package org.lfenergy.operatorfabric.cards.publication.configuration.mongo;

import org.bson.Document;
import org.lfenergy.operatorfabric.aop.process.mongo.models.UserActionTraceData;
import org.springframework.core.convert.converter.Converter;


public class TraceReadConverter implements Converter<Document, UserActionTraceData> {

    @Override
    public UserActionTraceData convert(Document source) {
        UserActionTraceData.UserActionTraceDataBuilder traceBuilder = UserActionTraceData.builder()
                .action(source.getString("action"))
                .cardUid(source.getString("cardUid"))
                .actionDate(source.getDate("actionDate").toInstant())
                .entities(source.getList("entities",String.class))
                .userName(source.getString("userName"));

        return traceBuilder.build();
    }
}
