/* Copyright (c) 2018-2020, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 * This file is part of the OperatorFabric project.
 */

import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LoggingFiltersComponent } from './logging-filters.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {DatetimeFilterModule} from '../../../../components/share/datetime-filter/datetime-filter.module';
import {MultiFilterModule} from '../../../../components/share/multi-filter/multi-filter.module';
import {Store, StoreModule} from '@ngrx/store';
import {appReducer, AppState, storeConfig} from '@ofStore/index';
import {ServicesModule} from '@ofServices/services.module';
import {HttpClientModule} from '@angular/common/http';
import {TranslateModule} from '@ngx-translate/core';
import {MonitoringFiltersComponent} from '../../../monitoring/components/monitoring-filters/monitoring-filters.component';
import {MonitoringTableComponent} from '../../../monitoring/components/monitoring-table/monitoring-table.component';
import {CardsModule} from '../../../cards/cards.module';
import {NO_ERRORS_SCHEMA} from '@angular/core';

describe('LoggingFiltersComponent', () => {
  let component: LoggingFiltersComponent;
  let fixture: ComponentFixture<LoggingFiltersComponent>;
  let store: Store<AppState>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [StoreModule.forRoot(appReducer, storeConfig),
        ServicesModule,
        HttpClientModule,
        TranslateModule.forRoot(),
        FormsModule,
        ReactiveFormsModule,
        DatetimeFilterModule,
        MultiFilterModule,
      CardsModule],
      declarations: [LoggingFiltersComponent],
      providers: [
        {provide: Store, useClass: Store}
      ],
      schemas: [ NO_ERRORS_SCHEMA ]
    })
        .compileComponents();
  }));

  beforeEach(() => {
    store = TestBed.get(Store);
    spyOn(store, 'dispatch').and.callThrough();
    fixture = TestBed.createComponent(LoggingFiltersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
